# Benchmarking Tool

This tool is a Flask web application to benchmark locally hosted language models (LLM). It allows to launch evaluations, follow logs in real-time, and download the results.

Currently, only local models in GGUF format are supported.

## Prerequisites

- >= Python 3.10
- Flask
- `llama-cpp-python`
- `lm-eval`
- `requests`
- `subprocess`
- GGUF models (some models are available here: https://huggingface.co/jaslatendresse)

You can also just `pip install -r requirements.txt` to install all the dependencies for this repository.

## Installation

1. **Clone the repository**:
```bash
git clone https://github.com/CQEN-QDCE/exp-os-assistant-redaction.git
cd exp-os-assistant-redaction/outil-benchmarking
```

2. **Create a virtual environment (recommended)**:
```bash
python3 -m venv venv
source venv/bin/activate # On Linux/macOS
venv\Scripts\activate # On Windows
```

3. **Install dependencies**:
```bash
pip install -r requirements.txt
```

4. **Place the GGUF models in the `models/` folder**:

5. **Configure inference parameters in the `inference_config.json` file**:

Modify the `inference_config.json` file to configure:
* The **port** of the server on which the model will be hosted (3001 by default).
* `n_gpu_layers`: the number of layer(s) to use for inference (99 by default, indicates that the execution is done entirely on GPU).
* `device`: the type of device to use for inference (`mps` for mac M1/M2/M3/M4 or `cuda`).

The other parameters are not currently used.

6. **Configure benchmarking parameters in the `benchmarking_config.json` file**:

Modify the `benchmarking_config.json` file to configure:
* `limit`: the number of samples to generate for benchmarking. To perform a complete benchmark, leave the value empty.

The other parameters are accessible through the user interface.

## Usage

1. **Put the GGUF models in the `models/` folder**:

2. **Launch the application**:

```bash
python3 app.py
```

3. **Access the application**:

Open a web browser and go to `http://localhost:8000/` to access the user interface.

4. **Start a benchmark**:

Select a model, enter the desired benchmarking parameters, and click the "Start Benchmarking" button.

Inference logs will appear in real time in the web interface. Once the benchmark is complete, a download button will appear to save the results.

Your results will be saved as a json file.
