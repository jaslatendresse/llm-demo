import huggingface_hub

model_id="meta-llama/Llama-3.1-8b-instruct"
directory="../models/hf_models"

huggingface_hub.snapshot_download(repo_id=model_id, local_dir=directory, local_dir_use_symlinks=False, revision="main")
