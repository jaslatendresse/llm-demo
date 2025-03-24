from flask import Flask, render_template, request, jsonify, send_from_directory, abort
import os
import subprocess
import time
import threading
import requests
import logging
import json

app = Flask(__name__)

with open("inference_config.json") as f:
    inference_config = json.load(f)

with open("benchmarking_config.json") as f:
    benchmarking_config = json.load(f)

MODEL_PORT = inference_config["port"]
N_GPU_LAYERS = inference_config["n_gpu_layers"]
LIMIT = benchmarking_config.get("limit")

MODELS_DIR = "../models"
RESULTS_FILE = "./benchmarking_results/results.json"
LOGS_FILE = "./logs/benchmarking_logs.log"
RESULTS_DIR = "benchmark_results"

os.makedirs("logs", exist_ok=True)

@app.route("/")
def index():
    return render_template("index.html", models=get_models(), tasks=get_tasks())

def get_models():
    return [f for f in os.listdir(MODELS_DIR) if f.endswith(".gguf")]

def get_tasks():
    return [
        "french_bench",
        "french_bench_mc",
        "french_bench_gen",
        "french_bench_perplexity",
        "belebele",
        "hellaswag",
        "hellaswag_fr",
        "mmlu",
        "mmlu_continuation",
        "mmlu_generation",
    ]

def start_inference_server(model_path):
    """Démarrage du serveur d'inférence."""
    print(f"🚀 Starting inference server with model: {model_path}")

    server_command = [
        "python3", "-m", "llama_cpp.server",
        "--model", model_path,
        "--n_gpu_layers", N_GPU_LAYERS,
        "--port", MODEL_PORT,
    ]

    server_process = subprocess.Popen(
        server_command,
        stdout=open("logs/inference_server.log", "w"),
        stderr=subprocess.STDOUT,
        preexec_fn=os.setsid
    )

    if wait_for_server():
        print("✅ Le serveur d'inférence en cours de démarrage.")
        return server_process

    else:
        print("❌ Échec du démarrage du serveur d'inférence.")
        server_process.terminate()
        return None

def wait_for_server(port=3001, timeout=60):
    """Attends que le serveur d'inférence démarre."""
    start_time = time.time()
    url = f"http://localhost:{port}/v1/completions"

    while time.time() - start_time < timeout:
        try:
            response = requests.post(url, json={"prompt": "", "max_tokens": 1})
            if response.status_code == 200:
                print("✅ Le serveur d'inférence est prêt.")
                return True
            else:
                print(f"⚠️ Server responded with status: {response.status_code}")
        except requests.exceptions.ConnectionError:
            print("⏳ En attente du serveur d'inférence...")

        time.sleep(2)

    print("❌ Timeout: Le serveur d'inférence n'a pas démarré.")
    return False

def run_benchmark(model, task, num_fewshot):
    """ Exécute eval.py et écrit les logs en temps réel. """
    command = [
        "python3", "scripts/eval.py",
        "--model", model,
        "--task", task,
        "--num_fewshot", str(num_fewshot),
    ]

    print(f"🚀 Exécution du benchmark: {' '.join(command)} --limit {LIMIT}")

    with open(LOGS_FILE, "w") as log_file:
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)

        for line in iter(process.stdout.readline, ""):
            log_file.write(line)
            log_file.flush()

        process.wait() # Wait for the process to finish

    return LOGS_FILE

@app.route("/start_benchmark", methods=["POST"])
def start_benchmark():
    data = request.json
    model = data.get("model")
    task = data.get("task")
    num_fewshot = data.get("num_fewshot")

    model_path = os.path.join(MODELS_DIR, model)

    server_process = start_inference_server(model_path)

    def run():
        run_benchmark(model, task, num_fewshot)
        print("Stopping inference server...")
        server_process.terminate()
        server_process.wait()
        # Signal benchmark completion
        app.config['benchmark_done'] = True
        app.config['benchmark_filename'] = f"{task}_{model}.json"

    app.config['benchmark_done'] = False # reset the done flag.
    threading.Thread(target=run).start()

    return jsonify({"message": "Benchmark started"})

@app.route("/benchmark_status", methods=["GET"])
def benchmark_status():
    """Check the status of the benchmark."""
    done = app.config.get('benchmark_done', False)
    filename = app.config.get('benchmark_filename', None)
    return jsonify({"done": done, "filename": filename})


@app.route("/logs", methods=["GET"])
def get_logs():
    if os.path.exists(LOGS_FILE):
        with open(LOGS_FILE, "r") as f:
            logs = f.readlines()
        return jsonify({"logs": logs})
    return jsonify({"logs": []})

@app.route("/documentation", methods=["GET"])
def documentation():
    return render_template("documentation.html")

@app.route("/download/<path:filename>", methods=["GET"])
def download_file(filename):
    """Serve the benchmark results file for download."""
    file_path = os.path.join(RESULTS_DIR, filename)

    if not os.path.exists(file_path):
        print(f"❌ File not found: {file_path}")
        abort(404)

    print(f"✅ Serving file: {file_path}")
    return send_from_directory(RESULTS_DIR, filename, as_attachment=True)

if __name__ == "__main__":
    class LogFilter(logging.Filter):
        def filter(self, record):
            return "/logs" not in record.getMessage() and "/benchmark_status" not in record.getMessage()

    log = logging.getLogger("werkzeug")
    log.addFilter(LogFilter())
    app.config['benchmark_done'] = False

    app.run(host="0.0.0.0", port=8000, debug=True)
