<div align="center">
  <img src="https://img.shields.io/badge/Neovim-%E2%99%A5-lightgrey" alt="Neovim">
  <img src="https://img.shields.io/github/license/privUr1x/nvim-profile" alt="License">
</div>

# nvim-profile

nvim-profile is a powerful Neovim configuration that enhances your editing experience with minimal setup.

## Features

- **Efficient Workflow**: Optimized for speed and productivity across various programming languages.
- **Plugin Management**: Uses Mason for seamless plugin installation and updates.
- **Beautiful Interface**: Aesthetic and ergonomic UI tailored for coding sessions.

## Installation

Before installing, ensure Neovim (v0.8.0+) is installed on your system. To install nvim-profile, follow these steps:

1. **Backup Existing Configuration** (Optional but recommended):
   ```sh
   mv ~/.config/nvim ~/.config/nvim.bak
   ```
⚠️ This step will overwrite any existing Neovim configurations in ~/.config/nvim.

2. Clone the Repository:
```sg
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
```

```sh
git clone https://github.com/privUr1x/nvim-profile.git ~/.config/nvim
```

3. Install Plugins:
Open Neovim and run the following command to install all required plugins:

```
:MasonInstallAll
```
⚠️ Make sure to run this command inside Neovim (nvim).

4. Start Neovim:
```sh
nvim
```
🚀 Neovim will now launch with the configured setup.
