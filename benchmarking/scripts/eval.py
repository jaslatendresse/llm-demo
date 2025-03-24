import os
import json
import argparse
from lm_eval.models.gguf import GGUFLM
import lm_eval

with open("inference_config.json") as f:
    inference_config = json.load(f)

with open("benchmarking_config.json") as f:
    benchmarking_config = json.load(f)

MODEL_PORT = inference_config["port"]
DEVICE = inference_config["device"]
LIMIT = benchmarking_config.get("limit")

def run_evaluation(model_name, task_name, num_fewshot=0, limit=LIMIT, device=DEVICE):
    results_dir = "benchmark_results"
    os.makedirs(results_dir, exist_ok=True)

    lm = GGUFLM(base_url=f"http://localhost:{MODEL_PORT}")
    print(f'Modèle {model_name} initialisé.')

    task_manager = lm_eval.tasks.TaskManager()
    print("Tâches initialisées.")

    results = lm_eval.simple_evaluate(
        model=lm,
        tasks=[task_name],
        device=device,
        num_fewshot=num_fewshot,
        limit=limit,
        task_manager=task_manager
    )
    print("✅ Evaluation complete.")

    results_file = os.path.join(results_dir, f"{task_name}_{model_name}.json")
    with open(results_file, "w") as json_file:
        json.dump(results, json_file, indent=4)

    print(f"📁 Results saved: {results_file}")
    return results_file

def main():
    parser = argparse.ArgumentParser(description="Run LLM benchmark")
    parser.add_argument("--model", type=str, required=True, help="Model name (GGUF file)")
    parser.add_argument("--task", type=str, required=True, help="Benchmarking task")
    parser.add_argument("--num_fewshot", type=int, help="Few-shot examples")

    args = parser.parse_args()

    print(f"Running benchmark {args.task} with {args.num_fewshot} few-shots...")
    print(f"Inference server running on port : {inference_config['port']}")
    print(f"GPU layers: {inference_config['n_gpu_layers']}")
    print(f"Device: {DEVICE}")
    print(f"Limit: {LIMIT}")

    run_evaluation(
        model_name=args.model,
        task_name=args.task,
        num_fewshot=args.num_fewshot,
    )

if __name__ == "__main__":
    main()
