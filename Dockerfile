# Base image
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR /opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Arguments
ARG PYTHON_VERSION=3.9
ARG USERNAME=hskim

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    wget bzip2 ca-certificates curl git vim \
    software-properties-common apt-transport-https nautilus \
    && rm -rf /var/lib/apt/lists/* && \
    # Configure git
    git config --global user.name "Hakseon97" && \
    git config --global user.email "gkrtjs0122@naver.com" && \
    useradd -ms /bin/bash $USERNAME
    
# Install Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_DIR \
    rm ~/miniconda.sh && \
    echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.bashrc \
    echo "conda activate base" >> ~/.bashrc && \
    . ~/.bashrc && \
    conda install python=${PYTHON_VERSION} -y && \
    conda clean -afy && \
    pip install --upgrade pip

SHELL ["/bin/bash", "--login", "-c"]

HEALTHCHECK CMD conda --version || exit 1

# Create and set working directory
WORKDIR /workspace

USER $USERNAME

# Set the default command to bash
CMD ["/bin/bash"]
