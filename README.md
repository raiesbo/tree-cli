# tree-cli

`tree` is a simple and flexible command-line tool written in Zig that recursively lists and displays directory structure and files directly in the terminal, compatible with any operating system.

## Example:

### Command

```bash
tree ./some_directory -a -c
```

### Output

```bash
·
├── build.zig.zon
├── build.zig
├── README.md
├── .gitignore
├── .git
└── src
    ├── main.zig
    ├── utils.zig
    └── tree.zig

2 directories, 8 files
```

## Instalation

Currently, the recommended way to use the CLI is to build the project locally and add the binary to your system's `PATH`.

### Steps:

1. Install [Zig](https://ziglang.org/) locally.
2. Run the following command to build the project:
```zig build```
3. Add the `/zig-out/bin/tree` directory to your system's `PATH`.

## Usage

```bash
tree [path-to-directory] [flags]
```
If no path is provided, `tree` will use the current directory.

### Arguments

| Flag/Argument       | Description                                      |
|---------------------|--------------------------------------------------|
| **Path (`.`)** | Selects the target directory if the provided path is valid. |
| **Help (`-h`, `--help`)** | Displays the help message with usage information. Overwrites other flags. |
| **Version (`-v`, `--version`)** | Shows the current version of the program. Overwrites other flags. |
| **Show Hidden Directories (`-a`, `-A`)** | Includes hidden directories in the output. |
| **Color Output (`-c`, `-C`)** | Enables colored output for better readability. |

## Contributing

Contributions are welcome! Feel free to open issues, suggest improvements or submit pull requests.
