#!/bin/bash

set -e

# Flags
INSTALL_PYTHON=false
INSTALL_NODE=false
INSTALL_DOCKER=false
INSTALL_TOOLS=false
INSTALL_DESKTOP=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --python) INSTALL_PYTHON=true ;;
    --node) INSTALL_NODE=true ;;
    --docker) INSTALL_DOCKER=true ;;
    --tools) INSTALL_TOOLS=true ;;
    --desktop) INSTALL_DESKTOP=true ;;
    --all)
      INSTALL_PYTHON=true
      INSTALL_NODE=true
      INSTALL_DOCKER=true
      INSTALL_TOOLS=true
      INSTALL_DESKTOP=true
      ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

# Update system
echo "🔄 Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Python, pip, pipx
if $INSTALL_PYTHON; then
  echo "🐍 Installing Python, pip, and pipx..."
  sudo apt install -y python3 python3-pip python3-venv
  python3 -m pip install --upgrade pip
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath
  echo "✅ Python, pip, pipx installed."
fi

# Install Node.js, npm, npx
if $INSTALL_NODE; then
  echo "🟢 Installing Node.js (LTS), npm, and npx..."
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install -y nodejs
  echo "✅ Node.js, npm, npx installed."
fi

# Install Docker & Docker Compose
if $INSTALL_DOCKER; then
  echo "🐳 Installing Docker and Docker Compose..."
  sudo apt install -y ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker "$USER"
  echo "✅ Docker and Docker Compose installed. You may need to log out and back in."
fi

# Install common developer tools
if $INSTALL_TOOLS; then
  echo "🧰 Installing developer tools (git, curl, zsh, etc)..."
  sudo apt install -y git curl wget build-essential unzip zip zsh tmux htop
  echo "✅ Common developer tools installed."

  # Git configuration
  read -p "Do you want to configure git? (y/n): " CONFIGURE_GIT
  if [[ "$CONFIGURE_GIT" == "y" ]]; then
    read -p "Enter your Git user name: " GIT_NAME
    read -p "Enter your Git email: " GIT_EMAIL
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global core.editor "nano"
    echo "✅ Git configured with name: $GIT_NAME and email: $GIT_EMAIL"
  fi
fi

echo "🎉 Setup complete!"
