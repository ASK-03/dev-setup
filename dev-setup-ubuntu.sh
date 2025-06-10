#!/bin/bash

set -e

# Flags
INSTALL_PYTHON=false
INSTALL_NODE=false
INSTALL_DOCKER=false
INSTALL_TOOLS=false
INSTALL_DESKTOP=false

# Detect OS and package manager
detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v apt >/dev/null 2>&1; then
      OS="debian"
      PKG_INSTALL="sudo apt install -y"
      PKG_UPDATE="sudo apt update && sudo apt upgrade -y"
    elif command -v dnf >/dev/null 2>&1; then
      OS="fedora"
      PKG_INSTALL="sudo dnf install -y"
      PKG_UPDATE="sudo dnf update -y"
    elif command -v pacman >/dev/null 2>&1; then
      OS="arch"
      PKG_INSTALL="sudo pacman -S --noconfirm"
      PKG_UPDATE="sudo pacman -Syu --noconfirm"
    else
      echo "❌ Unsupported Linux distribution."
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    if ! command -v brew >/dev/null 2>&1; then
      echo "🍺 Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    PKG_INSTALL="brew install"
    PKG_UPDATE="brew update && brew upgrade"
  else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
  fi
}

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

# Run OS detection
detect_os

# Update system
echo "🔄 Updating system..."
eval "$PKG_UPDATE"

# Python + pipx
if $INSTALL_PYTHON; then
  echo "🐍 Installing Python, pip, pipx..."
  case $OS in
    macos) $PKG_INSTALL python3 ;;
    *) $PKG_INSTALL python3 python3-pip python3-venv ;;
  esac
  python3 -m pip install --upgrade pip
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath
  echo "✅ Python stack installed."
fi

# Node.js
if $INSTALL_NODE; then
  echo "🟢 Installing Node.js..."
  if [[ "$OS" == "macos" ]]; then
    $PKG_INSTALL node
  else
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    $PKG_INSTALL nodejs
  fi
  echo "✅ Node.js installed."
fi

# Docker
if $INSTALL_DOCKER; then
  echo "🐳 Installing Docker..."
  case $OS in
    debian)
      $PKG_INSTALL ca-certificates curl gnupg lsb-release
      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt update
      $PKG_INSTALL docker-ce docker-ce-cli containerd.io docker-compose-plugin
      ;;
    fedora|arch)
      $PKG_INSTALL docker docker-compose
      ;;
    macos)
      brew install --cask docker
      ;;
  esac
  sudo usermod -aG docker "$USER" || true
  echo "✅ Docker installed."
fi

# Developer tools
if $INSTALL_TOOLS; then
  echo "🧰 Installing developer tools..."
  case $OS in
    macos) $PKG_INSTALL git curl wget zsh tmux htop unzip ;;
    *) $PKG_INSTALL git curl wget zsh tmux htop unzip zip build-essential ;;
  esac

  read -p "Do you want to configure git? (y/n): " CONFIGURE_GIT
  if [[ "$CONFIGURE_GIT" == "y" ]]; then
    read -p "Enter your Git user name: " GIT_NAME
    read -p "Enter your Git email: " GIT_EMAIL
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global core.editor "nano"
    echo "✅ Git configured."
  fi
fi

# Desktop apps
if $INSTALL_DESKTOP; then
  echo "🖥️ Installing desktop apps..."

  read -p "Install VS Code? (y/n): " INSTALL_VSCODE
  if [[ "$INSTALL_VSCODE" == "y" ]]; then
    case $OS in
      macos) brew install --cask visual-studio-code ;;
      debian)
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt update && sudo apt install -y code
        rm microsoft.gpg
        ;;
      fedora|arch) $PKG_INSTALL code ;;
    esac
    echo "✅ VS Code installed."
  fi

  read -p "Install Brave browser? (y/n): " INSTALL_BRAVE
  if [[ "$INSTALL_BRAVE" == "y" ]]; then
    case $OS in
      macos) brew install --cask brave-browser ;;
      debian)
        sudo apt install -y apt-transport-https curl
        curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo gpg --dearmor -o /usr/share/keyrings/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
          sudo tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update
        sudo apt install -y brave-browser
        ;;
      *) echo "Brave install not supported on $OS yet." ;;
    esac
    echo "✅ Brave browser installed."
  fi

  read -p "Install OBS Studio? (y/n): " INSTALL_OBS
  if [[ "$INSTALL_OBS" == "y" ]]; then
    case $OS in
      macos) brew install --cask obs ;;
      debian) sudo add-apt-repository ppa:obsproject/obs-studio -y && sudo apt update && sudo apt install -y obs-studio ;;
      fedora|arch) $PKG_INSTALL obs-studio ;;
    esac
    echo "✅ OBS Studio installed."
  fi

  read -p "Install VLC? (y/n): " INSTALL_VLC
  if [[ "$INSTALL_VLC" == "y" ]]; then
    case $OS in
      macos) brew install --cask vlc ;;
      *) $PKG_INSTALL vlc ;;
    esac
    echo "✅ VLC installed."
  fi
fi

echo "🎉 Setup complete for $OS!"
