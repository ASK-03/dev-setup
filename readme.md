# Development Environment Setup Script

This bash script is designed for Ubuntu systems to set up a development environment by installing essential tools and runtimes based on user-specified flags. It can install Python, Node.js, Docker, and common developer tools, and also updates the system before performing any installations.

## Features

- **System Update**: Updates the package list and upgrades installed packages.
- **Python Installation**: Installs Python 3, pip, pipx, and sets up a virtual environment.
- **Node.js Installation**: Installs the LTS version of Node.js along with npm and npx.
- **Docker Installation**: Installs Docker and Docker Compose, and adds the current user to the Docker group.
- **Developer Tools Installation**: Installs common tools like git, curl, zsh, tmux, and more.
- **Selective Installation**: Use flags to choose which components to install, or use `--all` to install everything.

## Requirements

- Ubuntu operating system (tested on Ubuntu 20.04 and later).
- Bash shell.
- Internet connection for downloading packages.
- Administrative privileges (the script uses `sudo`).

## Installation

1. **Download the script**: Save the script to a file, e.g., `setup.sh`.
2. **Make it executable**:
   ```bash
   chmod +x setup.sh
   ```
3. **Run the script** with the desired flags:
   ```bash
   ./setup.sh --python --node --docker --tools
   ```
   Or to install all components:
   ```bash
   ./setup.sh --all
   ```

## Usage

The script accepts the following flags to install specific components:

- `--python`: Installs Python 3, pip, pipx, and sets up the environment.
- `--node`: Installs Node.js (LTS), npm, and npx.
- `--docker`: Installs Docker and Docker Compose, and adds the current user to the Docker group.
- `--tools`: Installs common developer tools such as git, curl, wget, build-essential, unzip, zip, zsh, tmux, and htop.
- `--all`: Installs all of the above components.

### Example

To install Python and Docker:
```bash
./setup.sh --python --docker
```

**Note**: After installing Docker, you may need to log out and back in for the group changes to take effect.

## Verification

After running the script, you can verify the installations by checking the versions of the installed tools:

- Python: `python3 --version`
- pip: `pip3 --version`
- Node.js: `node --version`
- npm: `npm --version`
- Docker: `docker --version`
- Git: `git --version`
- Zsh: `zsh --version`

## Important Notes

- The script uses `set -e`, which means it will exit immediately if any command fails. This ensures that the script stops on errors, preventing partial installations.
- Since the script uses `sudo` to install packages and modify system settings, it requires administrative privileges. Please review the script before running it to ensure you are comfortable with the changes it makes.
- For Docker, if you encounter permission issues after installation, try logging out and back in, or rebooting the system to apply the group changes.

## Contributing

Contributions are welcome! If you have suggestions or improvements, please fork the repository and submit a pull request.