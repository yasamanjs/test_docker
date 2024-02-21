# Use an NVIDIA CUDA base image that includes CUDA 11.8 and is compatible with Ubuntu 20.04
FROM nvidia/cuda:11.8.0-base-ubuntu20.04

# Set the working directory
WORKDIR /usr/src/app

# Install Python 3.8 and essential packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        python3.8 python3.8-distutils python3.8-venv \
        curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pip for Python 3.8
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.8

# Remove existing python links if they exist and create new ones
RUN if [ -f /usr/bin/python ]; then rm /usr/bin/python; fi && \
    if [ -f /usr/bin/python3 ]; then rm /usr/bin/python3; fi && \
    ln -s /usr/bin/python3.8 /usr/bin/python3 && \
    ln -s /usr/bin/python3.8 /usr/bin/python


# Install compatible versions of torch, pandas, scipy, numpy, tqdm
# These versions are selected based on compatibility with Python 3.8 and PyTorch 2.1.2
RUN pip install torch pandas scipy numpy tqdm

# Optional: Clean up pip cache to save space
RUN rm -rf /root/.cache/pip/*

## step 1 (build the docker from script): "docker build ."
## #step 2 (build at the Seven Bridges address):
## docker build -t images.sb.biodatacatalyst.nhlbi.nih.gov/jamalyasa/nvidia_cuda_python:20240220v4 .
#step 3 (login to seven bridges): docker login images.sb.biodatacatalyst.nhlbi.nih.gov -u jamalyasa -p b566f33debac4c158b0eecea560a5654
#step 4 (Push to seven bridges adress):docker push images.sb.biodatacatalyst.nhlbi.nih.gov/jamalyasa/nvidia_cuda_python:20240220v3
