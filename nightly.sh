#!/bin/bash

## Download and set up nvim for mac or linux tarball as explained in the release
# https://github.com/neovim/neovim/releases

# Check if a destination directory is provided
if [ -z "$1" ]; then
    echo "Please provide a destination directory as an argument."
    exit 1
fi

destination="$1"

## if second parameter provided with file name, use it, otherwise use default
filename="${2:-nvim-macos-arm64.tar.gz}"

url="https://github.com/neovim/neovim/releases/download/nightly/$filename"


# Download the file
curl -L -o "$filename" "$url"

if [ $? -eq 0 ]; then
    echo "Download completed successfully."

    # Move the file to the destination
    mv "$filename" "$destination"

    # Change to the destination directory
    cd "$destination" || exit 1

    # Run the specified commands on the file
    if [[ "$OSTYPE" == "darwin"* ]]; then
        xattr -c "$filename"
    fi
    tar xzvf "$filename"

    if [ -d "nvim" ]; then
        rm -rf nvim
    fi
    # Rename the directory to nvim
    mv -f nvim-macos-arm64 nvim

    # Delete the downloaded file
    rm "$filename"

    echo "File processing completed successfully."
else
    echo "Download failed."
    exit 1
fi
