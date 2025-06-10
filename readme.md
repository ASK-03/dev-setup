# Development Environment Setup Script

This bash script sets up a development environment by installing essential tools and runtimes based on user-specified flags. It supports Python, Node.js, Docker, developer tools, and desktop apps.

## Features
- **System Update**: Updates and upgrades system packages.
- **Python Installation**: Installs Python 3, pip, pipx, and venv.
- **Node.js Installation**: Installs Node.js (LTS), npm, and npx.
- **Docker Installation**: Installs Docker and Docker Compose, adds user to Docker group.
- **Developer Tools**: Installs git, curl, wget, zsh, tmux, htop, unzip, and more.
- **Desktop Apps**: Optionally installs VS Code, Brave, OBS Studio, and VLC.
- **Selective Installation**: Use flags to choose components or `--all` for everything.

## Requirements
- Bash shell and internet connection.
- Administrative privileges (uses `sudo` or equivalent).
- Tested on Debian; compatibility with other OSes (Fedora, Arch, macOS) not fully verified.

## Installation
1. Save the script as `setup.sh`.
2. Make it executable: `chmod +x setup.sh`
3. Run with flags: `./setup.sh --python --node` or `./setup.sh --all`

## Usage
| Flag        | Description                              |
|-------------|------------------------------------------|
| `--python`  | Installs Python 3, pip, pipx, and venv.  |
| `--node`    | Installs Node.js (LTS), npm, and npx.    |
| `--docker`  | Installs Docker and Docker Compose.      |
| `--tools`   | Installs developer tools (git, curl, etc.). |
| `--desktop` | Prompts to install desktop apps (VS Code, Brave, etc.). |
| `--all`     | Installs all components.                 |

## OS Support
| Operating System | Package Manager | Supported Components                     | Notes                              |
|------------------|-----------------|------------------------------------------|------------------------------------|
| Debian-based     | apt             | Python, Node.js, Docker, Tools, Desktop   | Fully tested and verified.         |
| Fedora           | dnf             | Python, Node.js, Docker, Tools, Desktop   | Use with caution; not fully tested. |
| Arch             | pacman          | Python, Node.js, Docker, Tools, Desktop   | Use with caution; not fully tested. |
| macOS            | brew            | Python, Node.js, Docker, Tools, Desktop   | Use with caution; not fully tested. |

## Verification
Check versions: `python3 --version`, `node --version`, `docker --version`, etc.

## Notes
- Uses `set -e` to exit on errors.
- Log out and back in after Docker install for group changes.
- Tested on Debian; other OS support (Fedora, Arch, macOS) may vary—use with caution.