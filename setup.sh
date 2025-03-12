#!/bin/bash

# Get the directory of the script (i.e., where setup.sh is located)
REPO_DIR=$(dirname "$(realpath "$0")")

# Function to copy files
copy_files() {
    SRC="$1"
    DEST="$2"
    if [ -d "$SRC" ]; then
        echo "Copying directory: $SRC to $DEST"
        cp -r "$SRC" "$DEST"
    elif [ -f "$SRC" ]; then
        echo "Copying file: $SRC to $DEST"
        cp "$SRC" "$DEST"
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

            # Check if the target directory exists, and copy if it doesn't
            if [ -d "$HOME/.config/$dir_name" ] || [ -f "$HOME/.config/$dir_name" ]; then
                echo "Skipping $dir_name, already exists."
            else
                echo "Copying directory $dir_name to $HOME/.config/$dir_name"
                copy_files "$dir" "$HOME/.config/$dir_name"
            fi
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

                # Check if the target directory exists, and copy if it doesn't
                if [ -d "$HOME/.config/$dir_name" ] || [ -f "$HOME/.config/$dir_name" ]; then
                    echo "Skipping $dir_name, already exists."
                else
                    echo "Copying directory $dir_name to $HOME/.config/$dir_name"
                    copy_files "$dir" "$HOME/.config/$dir_name"
                fi
            fi
        done

        echo "Files copied successfully in Windows."
    else
        echo "No WSL or Windows environment detected. Using stow to manage dotfiles..."
        # Use stow to manage dotfiles on macOS or other environments
        stow .
    fi
fi
