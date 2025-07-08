# syntax=docker/dockerfile:1.3-labs

# The base-deps Docker image installs main libraries needed to run Ray

# The GPU options are NVIDIA CUDA developer images.
ARG BASE_IMAGE="ubuntu:22.04"
FROM ${BASE_IMAGE}
# FROM directive resets ARG
ARG BASE_IMAGE
# If this arg is not "autoscaler" then no autoscaler requirements will be included
ARG AUTOSCALER="autoscaler"
ENV TZ=America/Los_Angeles
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# TODO(ilr) $HOME seems to point to result in "" instead of "/home/ray"
ENV PATH "/home/ray/anaconda3/bin:$PATH"
ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION=3.11.6
ARG HOSTTYPE=${HOSTTYPE:-x86_64}

ARG RAY_UID=1000
ARG RAY_GID=100

RUN bash -c "set -euo pipefail && \
    apt-get update -y && \
    apt-get upgrade -y && \
    APT_PKGS=(sudo tzdata git libjemalloc-dev wget cmake g++ zlib1g-dev) && \
    if [[ \"$AUTOSCALER\" == \"autoscaler\" ]]; then \
        APT_PKGS+=(tmux screen rsync netbase openssh-client gnupg); \
    fi && \
    apt-get install -y \"\${APT_PKGS[@]}\" && \
    useradd -ms /bin/bash -d /home/ray ray --uid $RAY_UID --gid $RAY_GID && \
    usermod -aG sudo ray && \
    echo 'ray ALL=NOPASSWD: ALL' >> /etc/sudoers"

USER $RAY_UID
ENV HOME=/home/ray

COPY requirements_compiled.txt /home/ray/requirements_compiled.txt

SHELL ["/bin/bash", "-c"]

RUN bash -c "set -euo pipefail && \
    wget --quiet https://github.com/conda-forge/miniforge/releases/download/24.11.3-0/Miniforge3-24.11.3-0-Linux-${HOSTTYPE}.sh -O /tmp/miniforge.sh && \
    /bin/bash /tmp/miniforge.sh -b -u -p $HOME/anaconda3 && \
    $HOME/anaconda3/bin/conda init && \
    echo 'export PATH=$HOME/anaconda3/bin:$PATH' >> $HOME/.bashrc && \
    rm /tmp/miniforge.sh && \
    $HOME/anaconda3/bin/conda install -y libgcc-ng python=$PYTHON_VERSION && \
    $HOME/anaconda3/bin/conda install -y -c conda-forge libffi=3.4.2 && \
    $HOME/anaconda3/bin/conda clean -y --all && \
    wget -qO- https://astral.sh/uv/install.sh | sudo env UV_UNMANAGED_INSTALL=\"/usr/local/bin\" sh && \
    export PATH=$HOME/anaconda3/bin:$PATH && \
    PIP_PKGS=(setuptools==71.1.0 flatbuffers cython numpy psutil) && \
    if [[ \"$AUTOSCALER\" == \"autoscaler\" ]]; then \
        PIP_PKGS+=(redis six boto3 pyopenssl cryptography google-api-python-client google-oauth); \
    fi && \
    uv pip install --system --no-cache-dir --index-strategy unsafe-best-match -c $HOME/requirements_compiled.txt \"\${PIP_PKGS[@]}\" && \
    uv pip uninstall --system dask && \
    sudo apt-get autoremove -y cmake zlib1g-dev && \
    if [[ \"$BASE_IMAGE\" == \"ubuntu:22.04\" && \"$HOSTTYPE\" == \"x86_64\" ]]; then sudo apt-get autoremove -y g++; fi && \
    sudo rm -rf /var/lib/apt/lists/* && \
    sudo apt-get clean"

WORKDIR $HOME