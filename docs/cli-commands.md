# CLI Commands

## Installing the dependencies

Installs all the third party dependencies that the CLI needs to be able to generate the necessary files.

❗ Note: by default it will store these dependencies in `$HOME/.umbra/bin`.

```bash
Install external dependencies for umbra.

Usage: umbra install-deps
-h, --help    Print this usage information.
```

## Creating New Shaders

Create a new shader using the `umbra create` command.

For documentation about writing shaders that are compatible with Umbra, see the [general documentation](https://github.com/wolfenrain/umbra/tree/main/docs).

```bash
Create a new Umbra Shader.

Usage: umbra create <shader_name>
-h, --help                      Print this usage information.
-o, --output=<directory>        The output directory for the created file.
-t, --template=<template>       The template used to create this new shader.

          [simple] (default)    Create a simple shader.
          [translate]           Create a translating shader.
```

## Generating Files Based On Shaders

Generate files based on a Umbra Shader using the `umbra generate` command.

```bash
Generate different file types for a shader file.

Usage: umbra generate <subcommand> <shader_file>
-h, --help    Print this usage information.

Available subcommands:
  dart    Generate a Dart Shader file.
  raw     Generate a raw GLSL shader file.
  spirv   Generate a SPIR-V binary file.
```

### Dart Files

Generate a Dart file for Flutter that provides a strongly typed interface for the shader.

```bash
Generate a Dart Shader file.

Usage: umbra generate dart <shader_file>
-h, --help                  Print this usage information.
-o, --output=<directory>    The output directory for the generated files.
                            If "-" is given it will be written to stdout
```

### Raw GLSL Files

Generate a raw GLSL file that is used internally by Umbra for generating both the Dart files and SPIR-V binaries.

❗ Note: the output of this command can't be used for generating Dart files or SPIR-V binaries through the Umbra CLI.

```bash
Generate a raw GLSL shader file.

Usage: umbra generate raw <shader_file>
-h, --help                  Print this usage information.
-o, --output=<directory>    The output directory for the generated files.
                            If "-" is given it will be written to stdout
```

### SPIR-V Binaries

Generate a SPIR-V file that can be used as an asset for Flutter.

```bash
Generate a SPIR-V binary file.

Usage: umbra generate spirv <shader_file>
-h, --help                  Print this usage information.
-o, --output=<directory>    The output directory for the generated files.
                            If "-" is given it will be written to stdout
```
