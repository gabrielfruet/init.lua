# Neovim Lua Configuration 🌙

## Overview 📘
This repository hosts my personal Neovim configuration written in Lua. It's designed to enhance productivity and streamline the development workflow in Neovim.

## Installation 🚀
1. **Backup your current Neovim configuration** (if necessary):
   ```sh
   mv ~/.config/nvim ~/.config/nvim.backup
   ```
2. **Clone this repository**:
   ```sh
   git clone https://github.com/gabrielfruet/init.lua ~/.config/nvim
   ```
3. **Open Neovim** and the plugins will start installing automatically.

## Structure 🏗️
- `init.lua`: Entry point that loads all other configuration files.
- `lua/`: Contains all Lua files.
  - `fruet`
      - `loader.lua`: Loads my neovim custom configs and settings except for set.lua.
      - `lazy.lua`: Loads my plugins using the lazy manager.
      - `set.lua`: Neovim sets.

## Usage 📚
After installation, you can start Neovim and begin customizing the configuration to better suit your needs. Modify the Lua files in the `lua/` directory to tweak settings or add new functionality.
