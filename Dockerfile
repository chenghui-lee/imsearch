# Use an official image with Rust pre-installed
FROM rust:1.81.0 as builder

# Set up the Rust project
WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libomp-dev \
    libopencv-dev \
    wget \
    git \ 
    llvm-dev \
    libclang-dev \
    clang \
    libssl-dev \
    pkg-config \
    libgflags-dev \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Build and install Faiss from source
RUN git clone "https://github.com/facebookresearch/faiss.git" /faiss && \
    cd /faiss && \
    cmake -B build . -DFAISS_ENABLE_PYTHON=OFF -DFAISS_ENABLE_GPU=OFF -DFAISS_OPT_LEVEL=generic && \
    make -C build -j$(nproc) && \
    make -C build install

COPY . .

RUN cargo install --path . --root /usr/local

ENTRYPOINT ["/bin/bash", "-c", "while :; do sleep 10; done"]