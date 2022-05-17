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
  - [Commands](#commands)

## Overview

### Installation

```sh
# 🎯 Activate from https://pub.dev
dart pub global activate umbra_cli

# 🚀 Install umbra dependencies
umbra install-deps
```

## Commands

### `umbra install-deps`

`umbra install-deps` installs all the third party dependencies that the CLI needs to be able to generate the necessary files.

❗ Note: by default it will store these dependencies in `$HOME/.umbra/bin`.

### `umbra generate`

Generate files based on a given shader file:

TODO: gif here

#### Usage

```sh
# Generate the raw GLSL shader based on the given shader file
umbra generate raw ./shaders/simple.glsl --output ./shaders/simple_raw.glsl

# Generate a useable SPIRV file for Flutter based on the given shader file
umbra generate spirv ./shaders/simple.glsl --output ./assets/shaders

# Generate a strongly typed Dart file based on the given shader file
umbra generate dart ./shaders/simple.glsl --output ./lib/shaders
```

For documentation about  writing shaders that are compatible with Umbra, see the [general documentation](https://github.com/wolfenrain/umbra/tree/main/docs).
