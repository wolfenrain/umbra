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
Generate files based on an Umbra Shader.

Usage: umbra generate <shader_file>
-h, --help                           Print this usage information.
-o, --output=<directory>             The output directory for the created file(s).
-t, --target=<target>                The target used for generation.

          [dart-shader] (default)    Generate a Dart Shader.
          [flutter-widget]           Generate a Flutter Widget.
          [raw-shader]               Generate a raw GLSL shader.
          [spirv]                    Generate a Dart Shader.
```

❗ Note: the output of the `raw-shader` target can't be used for generating Dart files or SPIR-V binaries through the Umbra CLI.
