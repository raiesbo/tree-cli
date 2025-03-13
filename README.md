# Tree CLI

Tree CLI is a command-line application written in Zig that replicates the famous Linux tree command, which prints a
directory tree, including files, in the terminal.

Example:

```bash
·
├── LICENSE
├── build.zig.zon
├── build.zig
├── README.md
├── .gitignore
├── .git
└── src
    ├── main.zig
    ├── utils.zig
    └── tree.zig

Directories: 2 Files: 8
```

## Usege

```bash
tree <directory-path> <flags>
```

### Arguments

| Flag/Argument       | Description                                      |
|---------------------|--------------------------------------------------|
| **Path Argument (`.`)** | Selects the target directory if the provided path is valid. |
| **Help Flag (`-h`, `--help`)** | Displays the help message with usage information. Overwrites other flags. |
| **Version Flag (`-v`, `--version`)** | Shows the current version of the program. Overwrites other flags. |
| **Show Hidden Directories Flag (`-a`, `-A`)** | Includes hidden directories in the output. |
| **Color Output Flag (`-c`, `-C`)** | Enables colored output for better readability. |

### Example
```bash
tree ./some_directory -a -c
```

## Contributing

We are thankful for any contributions from the community.
