# Base image
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR /opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Arguments
ARG PYTHON_VERSION=3.9
ARG USERNAME=hskim97

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    wget bzip2 ca-certificates curl git vim mc \
    software-properties-common apt-transport-https nautilus \
    && rm -rf /var/lib/apt/lists/* \
    # Configure git
    && git config --global user.name "Hakseon97" \
    && git config --global user.email "gkrtjs0122@naver.com" \
    && useradd -ms /bin/bash $USERNAME
    
# Install Miniconda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && /bin/bash /tmp/miniconda.sh -b -p $CONDA_DIR \
    rm /tmp/miniconda.sh \
    && echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> /etc/bash.bashrc \
    && echo "conda activate base" >> /etc/bash.bashrc  \
    && . $CONDA_DIR/etc/profile.d/conda.sh  \
    && conda install python=${PYTHON_VERSION} -y  \
    && conda clean -afy  \
    && pip install --no-cache-dir --upgrade pip

SHELL ["/bin/bash", "--login", "-c"]

HEALTHCHECK CMD conda --version || exit 1

# Create and set working directory
WORKDIR /home/$USERNAME/workspace

USER $USERNAME

# Set the default command to bash
CMD ["/bin/bash"]
