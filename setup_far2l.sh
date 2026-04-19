#!/bin/bash

# Path for far2l configs
CONFIG_DIR="$HOME/.config/far2l/settings"
MACRO_DIR="$HOME/.config/far2l/Macros/scripts"
CONFIG_FILE="$CONFIG_DIR/key_macros.ini"
BACKUP_FILE="$CONFIG_FILE.bak"

# 1. Check for run
if pgrep -x "far2l" > /dev/null; then
    echo "❌ ERROR: far2l is currently runing!"
    echo "Please close the application complitely befire applying changes."
    exit 1
fi

mkdir -p "$CONFIG_DIR"
[ ! -f "$CONFIG_FILE" ] && touch "$CONFIG_FILE"

# 2. backup current ini
cp "$CONFIG_FILE" "$BACKUP_FILE"
echo "📦 Backup created: $BACKUP_FILE"

# 3. Check lua script 
if [ -d "$MACRO_DIR" ] && [ "$(ls -A "$MACRO_DIR" 2>/dev/null)" ]; then
    echo -e "\n⚠️  WARNING: Lua script found in $MACRO_DIR"
    echo "They may take precedence over macros from the .ini file."
fi

update_macro() {
    local key="$1"
    local desc="$2"
    local seq="$3"
    local section="KeyMacros/Shell/$key"

    # Remove any section containing the target description
    local tmp_file=$(mktemp)
    awk -v search="$desc" '
        /^\[/ { if (buffer ~ search) { buffer="" } else { printf "%s", buffer }; buffer=$0 "\n"; next }
        { buffer=buffer $0 "\n" }
        END { if (buffer !~ search) printf "%s", buffer }
    ' "$CONFIG_FILE" > "$tmp_file"
    mv "$tmp_file" "$CONFIG_FILE"

    # Append new section
    echo -e "\n[$section]\nDescription=$desc\nDisableOutput=0x1\nEmptyCommandLine=0x1\nSequence=$seq" >> "$CONFIG_FILE"
    echo "✅ Assigned: [$key] -> $desc"
}

echo -e "\n--- Navigation setup ---"

# 1. Parent folder
echo "Go back (Parent folder): 1) Backspace 2) Left Arrow"
read -p "Choice: " p_choice
case $p_choice in
    1) update_macro "BS" "Go to Parent Folder" "CtrlPgUp" ;;
    2) update_macro "Left" "Go to Parent Folder" "CtrlPgUp" ;;
esac

# 2. Child folder
echo -e "\nGo forward (Child folder): 1) Enter 2) Right Arrow"
read -p "Choice: " c_choice
case $c_choice in
    1) update_macro "Enter" "Go to Child Folder" "CtrlPgDn" ;;
    2) update_macro "Right" "Go to Child Folder" "CtrlPgDn" ;;
esac

# 3. Space key selection
echo -e "\nSelect files with Space?"
read -p " (y/n)?: " s_choice
if [[ $s_choice == "y" || $s_choice == "Y" ]];then
  update_macro "Space" "Select/Deselect and move down" "Ins"
fi

echo -e "\nSetup complited successfuly. You can now start far2l."

