# Inference from a user interface using Gradio

## Architecture

1. **Frontend**: Gradio
2. **Backend**: `llama2-wrapper` (a wrapper for the `llama.cpp` backend)

## Setup

**Step 1: Clone this repository**

`git clone https://github.com/jaslatendresse/llm-demo.git`

**Step 2: Navigate to the repository's folder and workspace**

`cd llm-demo/demo-ui`

**Step 3: Set up local environment**

```
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh

bash Miniforge3-MacOSX-arm64.sh

export PATH="/home/<YOUR_COMPUTER_USERNAME>/miniforge3/bin:$PATH"
```

This step will install Conda with the Miniforge installer (specific to ARM64 architectures) and ink the `conda` command to this installation. 

**Step 4: Create and activate the virtual environment**

```
conda create --name py310 python=3.10

conda activate py310
```

This will create a virtual environment with Python 3.10 named "py310" and activate it.

**Step 5: Setting up the backend**

We must manually install the backend dependency to specify that we want the backend to use metal acceleration. 

```
pip uninstall llama-cpp-python -y

CMAKE_ARGS="-DLLAMA_METAL=on" FORCE_CMAKE=1 pip install -U llama-cpp-python --no-cache-dir

pip install 'llama-cpp-python[server]'
```

**Step 6: Install other dependencies**

`pip install -r requirements.txt`

**Step 7: Download the model**

Inside the folder `demo-ui`, create a folder named `models`. 

Download the model `llama-2-7b-chat-gguf` on [HuggingFace](https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/blob/main/llama-2-7b-chat.Q4_0.gguf).

Put the model in the `demo-ui/models` folder. 

**All the commands for this can be found in `demo-ui/commands.txt`, just make sure to put your own username in the path.

## Execution

From the folder `demo-ui`, execute the command: 

`python app.py` or `python3 app.py`. 

Navigate to http://127.0.0.1:7860 to start talking with the model. 

## Important note

To adjust the number of GPU layers accordingly, you can do so by changing the value in `demo-ui/llama2_wrapper/model.py` on line 30. 

The current value is set at 8, which should be optimal for this setup, but you may need to change it depending on your hardware. 

## Model parameters

A full list of the model capabilities (such as the number of tokens in the context) can be found here.
