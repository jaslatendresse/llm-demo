# Local LLM Inference with `llama.cpp`

This repository is a complete tutorial and workspace to run LLMs locally using [`llama.cpp`](https://github.com/ggerganov/llama.cpp).

It walks you through:
* Setting up your environment
* Downloading models
* Converting a model from HF to GGUF
* Quantizing a model
* Running inference via CLI or launching a local web server.

## Repository Structure

```
llm-demo/					# Local clone of llm-demo
├── inference-cli.sh       	# Script to run inference in CLI mode (llama-cli)
├── inference-web.sh       	# Script to run llama-server for web-based inference
│
├── models/                	# Model storage (downloaded, converted, quantized)
│   ├── hf_models/         	# Hugging Face models (original)
│   └── model.gguf         	# Converted GGUF model (example)
│
├── scripts/               	# Utility scripts for model preparation
│   ├── download_model.py  	# Script to download models from HuggingFace
│   ├── convert.sh         	# Converts HF model to GGUF using llama.cpp
│   └── quantize.sh        	# Quantizes the converted GGUF model using llama.cpp
│
├── bencharmking/		      # Benchmarking tool
│
├── .gitignore             	# Git ignore file (to exclude models, etc.)
├── README.md              	# Project overview and instructions
└── requirements.txt       	# Python dependencies
```

## Setup your workspacce

1. **Create a virtual environment**:
```bash
conda create -n myenv python=3.10
conda activate myenv
```

2. **Clone llama.cpp**:
```bash
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
cmake -B build && cmake --build build --config Release  # Build llama.cpp
pip install -r requirements.txt
```

3. **Clone this repository**:
```bash
git clone https://github.com/jaslatendresse/llm-demo.git
cd llm-demo
mkdir models
mkdir models/hf_models
pip install -r requirements.txt
```

4. **Create a [HuggingFace token](https://huggingface.co/security-checkup?next=%2Fsettings%2Ftokens) with write permission and copy to clipboard.**

5. **Follow the instructions after running**:
```bash
huggingface-cli login
```

## Model Preparation

You can skip this step and directly download quantized models in GGUF format. Otherwise, this section walks you through the process of converting and quantizing a model.

1. **Download a model from HuggingFace**:

Set the model ID in `download_model.py` and run:
```bash
python3 scripts/download_model.py
```

This will download a model from HuggingFace and save it in `models/hf_models/` in HF format.

2. **Convert the model to GGUF**:

```bash
cd scripts
./convert.sh --cpp "PATH_TO_LLAMA.CPP" \
		--hf "PATH_TO_HF_MODEL" \
		--output "PATH_TO_OUTPUT_MODELS" \
		--quant "QUANTIZE TYPE <f32, f16, q8_0, q4_0>"
```

This will convert the model to GGUF format and save it in `models/`. In this step, you can already choose to quantize the model. The next step allows you to quantize it further.

If you get a "permission denied" error, run:
```bash
chmod +x scripts/convert.sh
```

3. **Quantize the model**:

This step allows you to quantize your model. You can skip this step if you have a very strong machine or if you have already quantized the model in the previous step.

Quantization types can be found in the [llama.cpp repository](https://github.com/ggml-org/llama.cpp/tree/master/examples/quantize).

```bash
cd scripts
./quantize.sh --cpp "PATH_TO_LLAMA.CPP" \
		--input "PATH_TO_GGUF_MODEL" \
		--output "OUTPUT_PATH" \
		--model "MODEL_NAME" \
		--quant "QUANTIZE TYPE"
```

This will quantize the model and save it in `models/` or the specified output path.

## Running Inference

These steps should be performed from the root of the workspace.

### CLI Mode

```bash
./inference-cli.sh --cpp "PATH/TO/LLAMA.CPP" \
			--model "PATH/TO/MODEL.gguf" \
			--prompt "YOUR PROMPT TEXT" \
			--temp 0.7 \
			--threads 0 \
			--gpu_layers 99
```

### Web Mode

```bash
./inference-web.sh --cpp "PATH/TO/LLAMA.CPP" \
			--model "PATH/TO/MODEL.gguf" \
			--temp 0.8 \
			--threads 0 \
			--gpu_layers 99 \
			--port 8080
```

Navigate to `http://localhost:8080` to access the web interface.

## Bencharking your models

This repository includes a workspace to benchmark your models on tasks like completion, generation, etc. The benchmarking tool is located in the `benchmarking/` folder.

The tasks are defined within [lm-eval-harness](https://github.com/EleutherAI/lm-evaluation-harness/).

To know more about how to run this tool, see the [README](https://github.com/jaslatendresse/llm-demo/tree/main/benchmarking/README.md) in the `benchmarking/` folder.

## References
* [llama.cpp](https://github.com/ggml-org/llama.cpp/)
* [lm-eval-harness](https://github.com/EleutherAI/lm-evaluation-harness/)

## Other Useful Links
* [HuggingFace](https://huggingface.co/)
* [EleutherAI](https://www.eleuther.ai/)
* [llama-cpp-python](https://github.com/abetlen/llama-cpp-python)
    * Python bindings for llama.cpp (essentially allows you to pip install llama.cpp and use it in Python)
