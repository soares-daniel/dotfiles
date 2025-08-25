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

GLAZEWM_CONFIG_DIR="/c/Users/d.a.soares/.glzr/glazewm"
ZEBAR_CONFIG_DIR="/c/Users/d.a.soares/.glzr/zebar"

# Check if we're in WSL
if grep -qEi "(microsoft|wsl)" /proc/version &>/dev/null; then
    echo "Running in WSL. Proceeding with file copy..."

    # Loop through all directories in the dotfiles repo
    for dir in "$REPO_DIR"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            echo "Processing $dir_name"
            if [ "$dir_name" == "bashrc" ]; then
                echo "Copying bashrc to $HOME/.bashrc"
                copy_files "$dir/.bashrc" "$HOME/.bashrc"
            fi
            # Copy files
            echo "Copying directory $dir_name to $HOME/.config/"
            copy_files "$dir" "$HOME/.config/"

            # Convert line endings of copied files in WSL
            if [ -d "$HOME/.config/$dir_name" ]; then
                echo "Converting line endings for copied files in $HOME/.config/$dir_name"
                find "$HOME/.config/$dir_name" -type f -print0 | xargs -0 dos2unix
            elif [ -f "$HOME/.config/$dir_name" ]; then
                 echo "Converting line endings for copied file $HOME/.config/$dir_name"
                 dos2unix "$HOME/.config/$dir_name"
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
                echo "Processing $dir_name"
                if [ "$dir_name" == "bashrc" ]; then
                    echo "Copying bashrc to $HOME/.bashrc"
                    copy_files "$dir_name/.bashrc" "$HOME/.bashrc"
                fi

                # Copy files to ~/.config/
                echo "Copying directory $dir_name to $HOME/.config/"
                copy_files "$dir" "$HOME/.config/"
            fi
        done

        # --- Specific Copying for GlazeWM and Zebar on Windows ---

        # Ensure target directories exist
          mkdir -p "$GLAZEWM_CONFIG_DIR"
          mkdir -p "$ZEBAR_CONFIG_DIR"

          # Copy GlazeWM config files (assuming they are in a directory named 'glazewm' in your dotfiles)
          GLAZEWM_DOTFILES_SOURCE="$REPO_DIR/glazewm"
          if [ -d "$GLAZEWM_DOTFILES_SOURCE" ]; then
              echo "Copying GlazeWM config from $GLAZEWM_DOTFILES_SOURCE to $GLAZEWM_CONFIG_DIR"
              copy_files "$GLAZEWM_DOTFILES_SOURCE" "$GLAZEWM_CONFIG_DIR/.." # Copy contents into .glzr/glazewm
          else
              echo "GlazeWM dotfiles source directory not found: $GLAZEWM_DOTFILES_SOURCE"
          fi

          # Copy Zebar config files (assuming they are in a directory named 'zebar' in your dotfiles)
          ZEBAR_DOTFILES_SOURCE="$REPO_DIR/zebar"
          if [ -d "$ZEBAR_DOTFILES_SOURCE" ]; then
              echo "Copying Zebar config from $ZEBAR_DOTFILES_SOURCE to $ZEBAR_CONFIG_DIR"
              copy_files "$ZEBAR_DOTFILES_SOURCE" "$ZEBAR_CONFIG_DIR/.." # Copy contents into .glzr/zebar
          else
              echo "Zebar dotfiles source directory not found: $ZEBAR_DOTFILES_SOURCE"
          fi

            echo "Files copied successfully in Windows."
        else
            echo "No WSL or Windows environment detected. Using stow to manage dotfiles..."
            # Use stow to manage dotfiles on macOS or other environments
            stow .
        fi
fi
