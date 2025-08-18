
# Use Debian 13 (Trixie) as base image
FROM debian:13

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install basic utilities
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        sudo \
        curl \
        git \
        bash \
        zsh \
        locales \
        ca-certificates \
        vim \
        less \
        procps \
        htop \
        unzip \
        wget \
        build-essential \
        openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Set default locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen


# Create devpetit user (custom for small dev environments)
RUN useradd -m devpetit && echo "devpetit ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER devpetit
WORKDIR /workspaces

# Set bash as default shell to match VS Code terminal
SHELL ["/bin/zsh", "-c"]
