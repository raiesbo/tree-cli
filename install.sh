#!/bin/zsh

# Build binary
zig build || { echo "Failed to compile the binary"; exit 1; }

# Move binary
OS=$(uname -s)
if [[ $OS == "Darwin" ]]; then 
    if [ -e zig-out/bin/tree ]; then
        echo "Moving binary to /usr/local/bin (requires sudo)"
        sudo mv -f zig-out/bin/tree /usr/local/bin/tree || { echo "Failed to move binary"; exit 1; }

        rm -rf zig-out
        echo "Binary installed successfully!"
    else
        echo "Unable to compile the binary file"
        exit 1
    fi
else
    echo "This installer only works in macOS"
    exit 1
fi
