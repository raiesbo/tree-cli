#!/bin/zsh

( exec zig build )

if [[ $OSTYPE == "darwin"* ]]; then 
    if [ -e zig-out/bin/tree ]; then
        mv -f zig-out/bin/tree /usr/local/bin/tree
        rm -rf zig-out
        echo "binary file successfully in place"
    else
        echo "unable to compile the binary file"
    fi
else
    echo "the installer only works in macOS"
fi
