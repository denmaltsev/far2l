# far2l Macro Setup Tool (macOS)

A Bash script to automate keyboard macro configuration for the **far2l** file manager on macOS. It simplifies folder navigation and file selection.

## Features

- **Automated Process Check**: Stops execution if `far2l` is running to prevent data loss.
- **Smart Update**: If a macro for a specific action already exists on a different key, the script removes the old binding before adding the new one.
- **Conflict Warning**: Detects existing Lua scripts that might override `.ini` macros.
- **Safety**: Automatically creates a backup (`key_macros.ini.bak`) before any changes.

## Configurable Actions

1. **Go to Parent Folder**: Choose between `Backspace` or `Left Arrow`.
2. **Go to Child Folder**: Choose between `Enter` or `Right Arrow`.
3. **File Selection**: Option to map `Space` to select/deselect files (like in Midnight Commander).

## Installation & Usage

1. **Download or create the script**:
   Save the script code as `setup_macros.sh`.

2. **Make it executable**:
```bash
chmod +x setup_macros.sh
```

3. **Run the script**
```bash
./setup_macros.sh
```

## Requirements
OS: nix based OS.
Application: far2l must be installed.
Terminal: Standard zsh or bash.

## Troubleshooting
* Macros not working? Check if you have Lua scripts in `~/.config/far2l/Macros/scripts`. Lua macros usually have higher priority.
* Restoring backup: If you want to revert changes, run:
```bash
cp ~/.config/far2l/settings/key_macros.ini.bak ~/.config/far2l/settings/key_macros.ini
```
