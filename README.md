# Tree CLI

Tree CLI is a command-line application written in Zig that emulates the popular Linux `tree` command. It displays directory structures, including files, directly in the terminal, compatible with any operating system.

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

2 directories, 8 files
```

## Instalation

Currently, the recommended way to use the CLI is to build the project locally and add the binary to your system's PATH.

### Steps:

1. Install [Zig](https://ziglang.org/) locally.
2. Run the following command to build the project:
```zig build```
3. Add the `/zig-out/bin/tree` directory to your system's PATH.

## Usage

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

We are thankful for any contributions.
