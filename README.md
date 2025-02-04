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

# Cheatsheet

## Jumps

```
C-i - go forth the jumplist
C-o - go back the jumplist
```

## Windows

```
C-w f - open file under cursor on split
C-w v - split current window vertically
C-w s - split current window horizontally
C-w w - go to next window
C-w c - close current window
```

# Normal mode

### Text motions
```
vis - visual select sentence(ends at '.', '!', '?', '\n', ' ' or '\t'
```


## Shell interaction
```vim
# Sending text to shell

:!command — Run `command` in the shell.
:'<,'>!command — Pipe the selected lines (`Visual mode`) to `command` and replace them with the output.
:range!command — Apply `command` to a specific range (e.g., `:1,5!sort`).

# Reading command output into buffer

:r !command — Insert the output of `command` **below** the current line.
:0r !command — Insert the output at the **top** of the file.
:$r !command — Insert the output at the **end** of the file.

# Replace entire buffer

:%!command — Pipe the **entire file** through `command` and replace it with the output.
:!ls — List files in the current directory.
:'<,'>!sort — Sort selected lines.

# Examples

:%!python — Run the whole file as a Python script and replace with the output.
:r !date — Insert the current date below the cursor.
:cexpr system('command') — Send `command` output to the quickfix list.
:silent !command — Run a shell command **without** showing the output.
:!! — Repeat the last shell command.
:!!command — Replace the last command with `command`.
```

