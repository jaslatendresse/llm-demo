# Hosting a large language model locally

This repository aims to guide you on how to do inference with a large language model locally. The demonstration is optimized for macOS, specifically the Apple Silicon chips (M1 in this case), and uses the llama-2-7b-chat model family (link available to download in the demos README). Note that the quantization may differ depending on your system and hardware. 

`demo-ui` will walk you through hosting your model locally and do inference from a user interface. This solution is more plug-and-play. 

`demo-terminal` will walk you through hosting your model locally and do inference from the terminal. This solution may be more customizable if you want to create your own user interface, and gives you access to a wider set of features from the model (inference, fine-tuning, etc).

**This repository is an aggregation of resources and what I have learned by trying to host a large language model locally. See the references at the end of this file.**

## Minimal requirements
 
To ensure the smooth operation of this demonstration, your system should meet the following minimal requirements:

* RAM: 16 GB,
* CPU: 8-core with 6 performance cores and 2 efficiency cores,
* GPU: 14-core
* Storage: 20 GB of free storage space on the disk to accommodate the model. 
* Environment: Ensure that you have Python installed (macOS users shouldn't have to worry about that).

See the README file of the respective folders on how to run the demonstrations. 

## TODO

* Add a research focused demo - how to do "batch" inference with llama-2 for research purposes, how to evaluate the outputs, how to capture the completion from the subprocess, etc.

## References

* [llama.cpp](https://github.com/ggerganov/llama.cpp)
* [Downloading models](https://huggingface.co/TheBloke)
* [Gradio](https://www.gradio.app/)
* [My slides](https://docs.google.com/presentation/d/1A2S3omOO6HJDGVB2EC4frDi5zGqggjqTSW0x01OVKQE/edit?usp=sharing)

## "Plug-and-Play" Resources

* [LM Studio](https://lmstudio.ai/) - UI that allows you to download models and run inference entirely offline. 
* [text-generation-webui](https://github.com/oobabooga/text-generation-webui) - Gradio web UI for LLMs.

## Really good dataset if you want to fine-tune a model on academic papers

[unarXive](https://github.com/IllDepence/unarXive)
