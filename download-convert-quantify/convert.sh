#!/bin/bash

helpFunction() {
   echo ""
   echo "Usage: $0 --cpp llama_path --hf hf_model_path --output output_path --quant quantization"
   echo -e "\t--cpp      Path to llama.cpp directory"
   echo -e "\t--hf       Path to the Hugging Face model directory"
   echo -e "\t--output   Output path for the converted model"
   echo -e "\t--quant    Quantization type (e.g., f16, q4_0, q5_1)"
   exit 1
}

# Manual parsing of long options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --cpp) llama_path="$2"; shift 2 ;;
    --hf) hf_model_path="$2"; shift 2 ;;
    --output) output_model="$2"; shift 2 ;;
    --quant) quantization="$2"; shift 2 ;;
    --help|-h) helpFunction ;;
    *) echo "Unknown option: $1"; helpFunction ;;
  esac
done

# Validate required args
if [ -z "$llama_path" ] || [ -z "$hf_model_path" ] || [ -z "$output_model" ] || [ -z "$quantization" ]; then
   echo "❌ Error: Some or all required parameters are missing."
   helpFunction
fi

# Execute conversion
cd "$llama_path" || { echo "Failed to cd into $llama_path"; exit 1; }

echo "✅ Running conversion..."
echo "Llama path: $llama_path"
echo "Model path: $hf_model_path"
echo "Output: $output_model"
echo "Quantization: $quantization"

python3 convert_hf_to_gguf.py "$hf_model_path" --outfile "$output_model" --outtype "$quantization"
