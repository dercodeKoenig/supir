# needs python 3.10
# also install the nvidia-driver5xx, not server, rtx5090 may need -open version

sudo apt update -y
sudo apt install python3.10 python3.10-venv python3.10-dev unzip -y
python3.10 -m venv .venv

# update pip
.venv/bin/python -m pip install --upgrade pip

# install correct torch version first
.venv/bin/python -m pip install --pre torch torchvision torchaudio

# prepare for building requirements
.venv/bin/python -m pip install wheel "setuptools<81.0.0"

# install requirements
.venv/bin/python -m pip install -r requirements.txt


## build xformers for rtx 5090, use cuda toolkit version that pytorch was compiled with
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-13-0
.venv/bin/python -m pip install ninja
# 12 for rtx5090
export TORCH_CUDA_ARCH_LIST="12.0"  
export CUDA_HOME=/usr/local/cuda-13.0
export PATH=/usr/local/cuda-13.0/bin:$PATH
.venv/bin/python -m pip install --no-build-isolation --no-cache-dir git+https://github.com/dercodeKoenig/xformers

#huggingface-cli download liuhaotian/llava-v1.5-13b --local-dir llava-v1.5-13b --local-dir-use-symlinks False
wget https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0_0.9vae.safetensors

curl -L -o weights.zip https://www.kaggle.com/api/v1/datasets/download/bpwqsdd/sdbsettjstjzk
unzip weights.zip
rm weights.zip

.venv/bin/python -m pip install jupyterlab ipykernel
.venv/bin/python -m ipykernel install --user --name=virtualenv --display-name "Python (supir)"

