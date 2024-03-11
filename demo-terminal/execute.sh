#!/bin/bash

model=llama-2-7b-chat.ggmlv3.q4_0.gguf.bin
path_to_model=/YOUR_PATH/llama.cpp/models
prompt="YOUR PROMPT"
ctx_size=1024 # The number of tokens in your prompt. Max is 2048
n_value=200 # The number of tokens returned in the model's response. Max is around 4096. 
temp=0.8 # The temperature of the model. Lower is more deterministic, higher is more random. Default is 0.8.
threads_value=8 # The number of threads to use. Depends on your hardware. 
n_gpu_layers=1 # The number of layers to use on the GPU. Depends on your hardware. 

# Inference command

./main -m ${path_to_model}/${model} -p "<s>[INST] ${prompt} [/INST]" --threads ${threads_value} --n-gpu-layers ${n_gpu_layers} --ctx-size ${ctx_size} -n ${n_value}

