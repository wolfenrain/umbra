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

For more information related to the CLI commands see the [CLI documentation](https://github.com/wolfenrain/umbra/tree/main/docs/cli-commands.md).

Documentation related to shaders can be found in the [Shader Specifications](https://github.com/wolfenrain/umbra/tree/main/docs/shader-specifications) documentation.
