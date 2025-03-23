#!/bin/bash

helpFunction() {
   echo ""
   echo "Usage: $0 --cpp llama_path --model model_file --temp temperature --threads num_threads --gpu_layers n_gpu_layers --port port_number"
   echo -e "\t--cpp         Path to llama.cpp directory"
   echo -e "\t--model       Full path to the GGUF model file"
   echo -e "\t--temp        Temperature for sampling (default: 0.8)"
   echo -e "\t--threads     Number of CPU threads to use"
   echo -e "\t--gpu_layers  Number of layers to run on GPU"
   echo -e "\t--port        Port number for the server (default: 8080)"
   exit 1
}

# Default values
temperature=0.8

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --cpp) llama_path="$2"; shift 2 ;;
    --model) model_file="$2"; shift 2 ;;
    --temp) temperature="$2"; shift 2 ;;
    --threads) threads_value="$2"; shift 2 ;;
    --gpu_layers) n_gpu_layers="$2"; shift 2 ;;
    --port) port_number="$2"; shift 2 ;;
    --help|-h) helpFunction ;;
    *) echo "Unknown option: $1"; helpFunction ;;
  esac
done

# Validate required parameters
if [ -z "$llama_path" ] || [ -z "$model_file" ] || [ -z "$threads_value" ] || [ -z "$n_gpu_layers" ] || [ -z "$port_number" ]; then
   echo "❌ Error: Some or all required parameters are missing."
   helpFunction
fi

cd "$llama_path" || { echo "Failed to cd into $llama_path"; exit 1; }

echo "✅ Starting llama-server..."
echo "Model: $model_file"
echo "Threads: $threads_value"
echo "GPU layers: $n_gpu_layers"
echo "Temperature: $temperature"
echo "Port: $port_number"

llama-server -m "$model_file" --temp "$temperature" --threads "$threads_value" --n-gpu-layers "$n_gpu_layers" --port "$port_number"
