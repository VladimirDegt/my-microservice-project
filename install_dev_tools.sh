#!/bin/bash

# Exit on error
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install Docker if not already installed
if command_exists docker; then
    echo "Docker is already installed."
else
    echo "Installing Docker..."
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker $USER
    echo "Docker installed successfully."
fi

# Install Docker Compose if not already installed
if command_exists docker-compose; then
    echo "Docker Compose is already installed."
else
    echo "Installing Docker Compose..."
    DOCKER_COMPOSE_VERSION="2.29.2"
    sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
fi

# Install Python 3.9 or newer if not already installed
if command_exists python3 && python3 --version | grep -q "3.[9-11]"; then
    echo "Python 3.9 or newer is already installed."
else
    echo "Installing Python..."
    sudo apt-get install -y python3 python3-pip python3-venv
    echo "Python installed successfully."
fi

# Install Django if not already installed
if python3 -m pip show django >/dev/null 2>&1; then
    echo "Django is already installed."
else
    echo "Installing Django..."
    python3 -m pip install django
    echo "Django installed successfully."
fi

echo "All development tools installed successfully!"