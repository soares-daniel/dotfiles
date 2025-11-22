#!/bin/bash

# Get the directory of the script (i.e., where setup.sh is located)
REPO_DIR=$(dirname "$(realpath "$0")")

# Function to copy files
copy_files() {
    SRC="$1"
    DEST="$2"
    if [ -d "$SRC" ]; then
        echo "Copying directory: $SRC to $DEST"
        cp -ru "$SRC" "$DEST"  # -r: recursive, -u: update only if newer
    elif [ -f "$SRC" ]; then
        echo "Copying file: $SRC to $DEST"
        cp -u "$SRC" "$DEST"
    else
        echo "Source $SRC does not exist"
    fi
}

# Check if we're in WSL
if grep -qEi "(microsoft|wsl)" /proc/version &>/dev/null; then
    echo "Running in WSL. Proceeding with file copy..."

    # Loop through all directories in the dotfiles repo
    for dir in "$REPO_DIR"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")

            # Copy files even if target directory exists
            echo "Copying directory $dir_name to $HOME/.config/$dir_name"
            copy_files "$dir" "$HOME/.config/"
        fi
    done

    echo "Files copied successfully in WSL."
else
    # If not in WSL, check if we're in Windows environment
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "Running on native Windows. Proceeding with file copy..."

        # Loop through all directories in the dotfiles repo
        for dir in "$REPO_DIR"/*; do
            if [ -d "$dir" ]; then
                dir_name=$(basename "$dir")

                # Copy files even if target directory exists
                echo "Copying directory $dir_name to $HOME/.config/$dir_name"
                copy_files "$dir" "$HOME/.config/"
            fi
        done

        echo "Files copied successfully in Windows."
    else
        echo "No WSL or Windows environment detected. Using stow to manage dotfiles..."
        # Use stow to manage dotfiles on macOS or other environments
        stow .
    fi
fi

# --- Link the main bashrc ---
TARGET="$HOME/.bashrc"
SOURCE="$HOME/.config/bashrc/.bashrc"

if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
  echo "⚠️  Found existing $TARGET (not a symlink). Backing up to $TARGET.bak"
  mv "$TARGET" "$TARGET.bak"
fi

ln -sf "$SOURCE" "$TARGET"
echo "✅ Linked $TARGET → $SOURCE"
