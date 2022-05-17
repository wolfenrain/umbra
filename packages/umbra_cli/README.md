<h1 align="center">
Umbra CLI
</h1>

<p align="center">
<a href="https://pub.dev/packages/umbra_cli"><img src="https://img.shields.io/pub/v/umbra_cli.svg" alt="Pub"></a>
<a href="https://github.com/wolfenrain/umbra/actions"><img src="https://github.com/wolfenrain/umbra/workflows/umbra_cli/badge.svg" alt="umbra_cli"></a>
<a href="https://github.com/wolfenrain/umbra/actions"><img src="https://raw.githubusercontent.com/wolfenrain/umbra/main/packages/umbra_cli/coverage_badge.svg" alt="coverage"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
</p>

---

Umbra CLI allows Flutter developers to create their own shaders and compile them to strongly typed dart files.

## Quick start

```sh
# 🎯 Activate from https://pub.dev
dart pub global activate umbra_cli

# 🚀 Install umbra dependencies
umbra install-deps

# 🕶️ Create your first shader
umbra create hello_world

# 📦 Compile your first shader to a Dart file
umbra generate dart shaders/hello_world.glsl --output lib/shaders/
```

---

## Table of Contents

- [Overview](#overview)
  - [Installation](#installation)
- [Creating New Shaders](#creating-new-shaders)
- [Generating Files Based On Shaders](#generating-files-based-on-shaders)
  - [Dart Files](#dart-files)
  - [Raw GLSL files](#raw-glsl-files)
  - [SPIR-V Binaries](#spir-v-binaries)
## Overview

### Installation

```sh
# 🎯 Activate from https://pub.dev
dart pub global activate umbra_cli

# 🚀 Install umbra dependencies
umbra install-deps
```

`umbra install-deps` installs all the third party dependencies that the CLI needs to be able to generate the necessary files.

❗ Note: by default it will store these dependencies in `$HOME/.umbra/bin`.

## Creating New Shaders

Create a new shader using the `umbra create` command.

For documentation about writing shaders that are compatible with Umbra, see the [general documentation](https://github.com/wolfenrain/umbra/tree/main/docs).

```sh
# Create a new shader in the current directory.
umbra create <SHADER_NAME>

# Create a new shader in a custom path.
umbra create <SHADER_NAME> --output ./path/to/shader/files

# Create a new shader in a custom path short-hand syntax.
umbra create <SHADER_NAME> -o ./path/to/shader/files
```

## Generating Files Based On Shaders

Generate files based on a Umbra Shader using the `umbra generate` command.

### Dart Files

Generate a Dart file for Flutter that provides a strongly typed interface for the shader.

```sh
# Generate a Dart file in a custom path.
umbra generate dart my_shader.glsl --output ./path/to/dart/files

# Generate a Dart file in a custom path short-hand syntax.
umbra generate dart my_shader.glsl -o ./path/to/dart/files

# Generate a Dart file and output it to stdout.
umbra generate raw my_shader.glsl --output -
```

### Raw GLSL Files

Generate a raw GLSL file that is used internally by Umbra for generating both the Dart files and SPIR-V binaries.

❗ Note: the output of this command can't be used for generating Dart files nor SPIR-V binaries through the umbra CLI.

```sh
# Generate a raw GLSL file in a custom path.
umbra generate raw my_shader.glsl --output ./path/to/dart/files

# Generate a raw GLSL file in a custom path short-hand syntax.
umbra generate raw my_shader.glsl -o ./path/to/dart/files

# Generate a raw GLSL file and output it to stdout.
umbra generate raw my_shader.glsl --output -
```

### SPIR-V Binaries

Generate a SPIR-V file that can be used as an asset for Flutter.

```sh
# Generate a SPIR-V binary in a custom path.
umbra generate spirv my_shader.glsl --output ./path/to/spirv/files

# Generate a SPIR-V binary in a custom path short-hand syntax.
umbra generate spirv my_shader.glsl -o ./path/to/spirv/files

# Generate a SPIR-V binary and output it to stdout.
umbra generate spirv my_shader.glsl --output -
```
