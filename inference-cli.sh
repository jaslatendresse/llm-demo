#!/bin/bash

helpFunction() {
   echo ""
   echo "Usage: $0 --cpp llama_path --model model_file --prompt prompt_text --temp temperature --threads num_threads --gpu_layers n_gpu_layers"
   echo -e "\t--cpp         Path to llama.cpp directory"
   echo -e "\t--model       Full path to the model file (.gguf)"
   echo -e "\t--prompt      Prompt text to send to the model"
   echo -e "\t--temp        Temperature for sampling (default: 0.8)"
   echo -e "\t--threads     Number of CPU threads to use"
   echo -e "\t--gpu_layers  Number of layers to run on GPU"
   exit 1
}

temperature=0.8

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --cpp) llama_path="$2"; shift 2 ;;
    --model) model_file="$2"; shift 2 ;;
    --prompt) prompt_text="$2"; shift 2 ;;
    --temp) temperature="$2"; shift 2 ;;
    --threads) threads_value="$2"; shift 2 ;;
    --gpu_layers) n_gpu_layers="$2"; shift 2 ;;
    --help|-h) helpFunction ;;
    *) echo "Unknown option: $1"; helpFunction ;;
  esac
done

if [ -z "$llama_path" ] || [ -z "$model_file" ] || [ -z "$prompt_text" ] || [ -z "$threads_value" ] || [ -z "$n_gpu_layers" ]; then
   echo "❌ Error: Some or all required parameters are missing."
   helpFunction
fi

cd "$llama_path" || { echo "Failed to cd into $llama_path"; exit 1; }

echo "✅ Running llama-cli..."
echo "Model: $model_file"
echo "Prompt: $prompt_text"
echo "Threads: $threads_value, GPU layers: $n_gpu_layers, Temp: $temperature"

llama-cli -m "$model_file" -p "<s>[INST] $prompt_text [/INST]" --temp "$temperature" --threads "$threads_value" --n-gpu-layers "$n_gpu_layers"
