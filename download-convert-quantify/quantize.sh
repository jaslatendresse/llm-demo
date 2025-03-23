#!/bin/bash

helpFunction() {
   echo ""
   echo "Usage: $0 --cpp llama_path --input input_path --output output_path --model model_name --quant quantization_type"
   echo -e "\t--cpp      Path to llama.cpp directory"
   echo -e "\t--input    Path to the input model (unquantized .gguf)"
   echo -e "\t--output   Path where the quantized model will be saved"
   echo -e "\t--model    Name of the output model file (e.g., model-q4.gguf)"
   echo -e "\t--quant    Quantization type (e.g., f32, f16, q4_0, q5_1, q8_0)"
   exit 1
}

# Manual parsing of long options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --cpp) llama_path="$2"; shift 2 ;;
    --input) input_path="$2"; shift 2 ;;
    --output) output_path="$2"; shift 2 ;;
    --model) model_name="$2"; shift 2 ;;
    --quant) quant_type="$2"; shift 2 ;;
    --help|-h) helpFunction ;;
    *) echo "Unknown option: $1"; helpFunction ;;
  esac
done

# Validate required parameters
if [ -z "$llama_path" ] || [ -z "$input_path" ] || [ -z "$output_path" ] || [ -z "$model_name" ] || [ -z "$quant_type" ]; then
   echo "❌ Error: Some or all required parameters are missing."
   helpFunction
fi

# Execute command
cd "$llama_path" || { echo "Failed to cd into $llama_path"; exit 1; }

echo "✅ Running llama-quantize..."
echo "Input model: $input_path"
echo "Output path: $output_path/$model_name"
echo "Quantization type: $quant_type"

llama-quantize "$input_path" "$output_path/$model_name" "$quant_type"
