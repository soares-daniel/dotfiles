#!/bin/bash

# Get the directory of the script (i.e., where setup.sh is located)
REPO_DIR=$(dirname "$(realpath "$0")")

# Check if we're in WSL
if grep -qEi "(microsoft|wsl)" /proc/version &>/dev/null; then
    echo "Running in WSL. Proceeding with symlink creation..."

    # Loop through all directories in the dotfiles repo
    for dir in "$REPO_DIR"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")

            # Check if the target directory exists on Windows side, create a symlink using ln
            if [ -d "$HOME/.config/$dir_name" ] || [ -f "$HOME/.config/$dir_name" ]; then
                echo "Skipping $dir_name, already exists."
            else
                echo "Creating symlink for $dir_name using ln"
                ln -s "$dir" "$HOME/.config/$dir_name"
            fi
        fi
    done

    echo "Symlinks created successfully in WSL."
else
    # If not in WSL, check if we're in Windows environment
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "Running on native Windows. Proceeding with mklink creation..."

        # Loop through all directories in the dotfiles repo
        for dir in "$REPO_DIR"/*; do
            if [ -d "$dir" ]; then
                dir_name=$(basename "$dir")

                # Check if the target directory exists on Windows side, create a symlink using mklink
                if [ -d "$HOME/.config/$dir_name" ] || [ -f "$HOME/.config/$dir_name" ]; then
                    echo "Skipping $dir_name, already exists."
                else
                    echo "Creating symlink for $dir_name using mklink"
                    cmd.exe /c "mklink /D $HOME/.config/$dir_name $dir"
                fi
            fi
        done

        echo "Symlinks created successfully in Windows."
    else
        echo "No WSL or Windows environment detected. Using stow to create symlinks..."
        stow .
    fi
fi
