# Inference from the terminal

## Setup 

#### Step 1: Clone this repository

`git clone https://github.com/jaslatendresse/llm-demo.git`

#### Step 2: Clone the backend

`git clone https://github.com/ggerganov/llama.cpp.git`

#### Step 3: Navigate to the backend

`cd llama.cpp`

#### Step 4: Build the repository

`make`

On macOS, Metal is automatically activated which allows the execution to be on GPU. 

#### Step 5: Download the model

`wget https://huggingface.co/TheBloke/Llama-2-7B-chat-GGML/resolve/main/llama-2-7b-chat.ggmlv3.q4_0.bin`

#### Step 6: Save the model

Put the model in the `models` folder of the `llama.cpp` repository. If the folder doesn't exist, create it. 

#### Step 7: Convert the model to the proper format

GGML models are no longer supported by llama.cpp. However, I could not find a GGUF model that worked with this demo. The solution is to convert the model. 

Within the `llama.cpp` folder, execute: `./convert-llama-ggml-to-gguf.py --eps 1e-5 -i ./models/llama-2-7b-chat.ggmlv3.q4_0.bin -o ./models/llama-2-7b-chat.ggmlv3.q4_0.gguf.bin`. [Source](https://huggingface.co/TheBloke/Llama-2-13B-chat-GGML/discussions/14)

## Usage

From inside the script `execute.sh`, you can set your prompt. The parameters are already set by default, but you can adjust them accordingly. SAVE YOUR FILE WITH THE CHANGES. 

Don't forget to change your paths. 

Navigate to the `llama.cpp` repository `cd path/to/llama.cpp`. 

Execute the command `sh path/to/execute.sh` from within `llama.cpp`. 

## Features

Below are the options and parameters that can be used with the inference function (`main`). These parameters were found on the [llama.cpp](https://github.com/ggerganov/llama.cpp) repository. 

| Short Option | Long Option            | Description |
|--------------|------------------------|-------------|
| `-h`         | `--help`               | show this help message and exit |
| `-i`         | `--interactive`        | run in interactive mode |
|              | `--interactive-first`  | run in interactive mode and wait for input right away |
| `-ins`       | `--instruct`           | run in instruction mode (use with Alpaca models) |
|              | `--multiline-input`    | allows you to write or paste multiple lines without ending each in '\' |
| `-r PROMPT`  | `--reverse-prompt PROMPT` | halt generation at PROMPT, return control in interactive mode (can be specified more than once for multiple prompts) |
|              | `--color`              | colorise output to distinguish prompt and user input from generations |
| `-s SEED`    | `--seed SEED`          | RNG seed (default: -1, use random seed for < 0) |
| `-t N`       | `--threads N`          | number of threads to use during computation (default: 6) |
| `-p PROMPT`  | `--prompt PROMPT`      | prompt to start generation with (default: empty) |
| `-e`         |                        | process prompt escapes sequences (\n, \r, \t, \', \", \\) |
|              | `--prompt-cache FNAME` | file to cache prompt state for faster startup (default: none) |
|              | `--prompt-cache-all`   | if specified, saves user input and generations to cache as well. Not supported with --interactive or other interactive options |
|              | `--prompt-cache-ro`    | if specified, uses the prompt cache but does not update it. |
|              | `--random-prompt`      | start with a randomized prompt. |
|              | `--in-prefix STRING`   | string to prefix user inputs with (default: empty) |
|              | `--in-suffix STRING`   | string to suffix after user inputs with (default: empty) |
| `-f FNAME`   | `--file FNAME`         | prompt file to start generation. |
| `-n N`       | `--n-predict N`        | number of tokens to predict (default: -1, -1 = infinity) |
| `-c N`       | `--ctx-size N`         | size of the prompt context (default: 512) |
| `-b N`       | `--batch-size N`       | batch size for prompt processing (default: 512) |
| `-gqa N`     | `--gqa N`              | grouped-query attention factor (TEMP!!! use 8 for LLaMAv2 70B) (default: 1) |
| `-eps N`     | `--rms-norm-eps N`     | rms norm eps (TEMP!!! use 1e-5 for LLaMAv2) (default: 1.0e-06) |
|              | `--top-k N`            | top-k sampling (default: 40, 0 = disabled) |
|              | `--top-p N`            | top-p sampling (default: 0.9, 1.0 = disabled) |
|              | `--tfs N`              | tail free sampling, parameter z (default: 1.0, 1.0 = disabled) |
|              | `--typical N`          | locally typical sampling, parameter p (default: 1.0, 1.0 = disabled) |
|              | `--repeat-last-n N`    | last n tokens to consider for penalize (default: 64, 0 = disabled, -1 = ctx_size) |
|              | `--repeat-penalty N`   | penalize repeat sequence of tokens (default: 1.1, 1.0 = disabled) |
|              | `--presence-penalty N` | repeat alpha presence penalty (default: 0.0, 0.0 = disabled) |
|              | `--frequency-penalty N`| repeat alpha frequency penalty (default: 0.0, 0.0 = disabled) |
|              | `--mirostat N`         | use Mirostat sampling. Top K, Nucleus, Tail Free and Locally Typical samplers are ignored if used. (default: 0, 0 = disabled, 1 = Mirostat, 2 = Mirostat 2.0) |
|              | `--mirostat-lr N`      | Mirostat learning rate, parameter eta (default: 0.1) |
|              | `--mirostat-ent N`     | Mirostat target entropy, parameter tau (default: 5.0) |
| `-TOKEN_ID(+/-)BIAS` | `--logit-bias TOKEN_ID(+/-)BIAS` | modifies the likelihood of token appearing in the completion, i.e. `--logit-bias 15043+1` to increase likelihood of token ' Hello' or `--logit-bias 15043-1` to decrease likelihood of token ' Hello'|
| | `--grammar GRAMMAR`| BNF-like grammar to constrain generations (see samples in grammars/ dir)|
| | `--grammar-file FNAME` | file to read grammar from |
| | `--cfg-negative-prompt PROMPT` | negative prompt to use for guidance. (default: empty) |
| | `--cfg-scale N` |  strength of guidance (default: 1.000000, 1.0 = disable) |
| | ` --rope-freq-base N` | RoPE base frequency (default: 10000.0) |
| | `--rope-freq-scale N` | RoPE frequency scaling factor (default: 1) |
| | `--ignore-eos` | ignore end of stream token and continue generating (implies --logit-bias 2-inf) |
| | `--no-penalize-nl` | do not penalize newline token | 
| | `--memory-f32` | use f32 instead of f16 for memory key+value (default: disabled) not recommended: doubles context memory required and no measurable increase in quality | 
| | `--temp N` | temperature (default: 0.8) |
| | `--perplexity` |compute perplexity over each ctx window of the prompt | 
| | `--perplexity-lines` |compute perplexity over each line of the prompt | 
| | `--keep` |number of tokens to keep from the initial prompt (default: 0, -1 = all) | 
| | `--chunks N` | max number of chunks to process (default: -1, -1 = all)| 
| | `--mlock` | force system to keep model in RAM rather than swapping or compressing| 
| | `--no-mmap ` | do not memory-map model (slower load but may reduce pageouts if not using mlock)| 
| | `--numa` | attempt optimizations that help on some NUMA systems, if run without this previously, it is recommended to drop the system page cache before using this. see https://github.com/ggerganov/llama.cpp/issues/1437| 
| `-ngl N` | `--n-gpu-layers N` |number of layers to store in VRAM| 
|`-ts SPLIT` | `--tensor-split SPLIT` | how to split tensors across multiple GPUs, comma-separated list of proportions, e.g. 3,1| 
|`-mg i`| `--main-gpu i` |the GPU to use for scratch and small tensors | 
|`-lv` | `--low-vram` | don't allocate VRAM scratch buffer| 
| | `--mtest` |compute maximum memory usage | 
| | `--export` |export the computation graph to 'llama.ggml' | 
| | `--verbose-prompt` | print prompt before generation|
| | `--lora FNAME` |apply LoRA adapter (implies --no-mmap) |
| | `--lora-base FNAME` | optional model to use as a base for the layers modified by the LoRA adapter|
| `-m FNAME` | `--model FNAME` | model path (default: models/7B/ggml-model.bin) |