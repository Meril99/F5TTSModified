FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

USER root

ARG DEBIAN_FRONTEND=noninteractive

LABEL github_repo="https://github.com/SWivid/F5-TTS"

# Install dependencies
RUN set -x \
    && apt-get update \
    && apt-get -y install wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
    && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set the working directory
WORKDIR /workspace

# Copy both directories
COPY ./F5-TTS /workspace/F5-TTS
COPY ./src /workspace/src

# Remove existing f5_tts and install local version
RUN rm -rf /usr/local/lib/python3.10/site-packages/f5_tts
RUN cd /workspace/F5-TTS && pip install -e . --no-cache-dir

# Debug: Verify correct path
RUN python -c "import f5_tts; print(f5_tts.__file__)"

# Add src directories to Python path
ENV PYTHONPATH="/workspace/src:/workspace/F5-TTS/src:$PYTHONPATH"

# Debug: Verify files
RUN echo "Outer src contents:" && ls -l /workspace/src/f5_tts/infer/
RUN echo "Inner src contents:" && ls -l /workspace/F5-TTS/src/f5_tts/infer/

# Set environment variables
ENV SHELL=/bin/bash

# Default command
CMD ["python", "-m", "f5_tts.infer.infer_cli"]
