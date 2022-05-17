<h1 align="center">
Umbra
</h1>

<p align="center">
<a href="https://github.com/wolfenrain/umbra/actions"><img src="https://github.com/wolfenrain/umbra/workflows/umbra/badge.svg" alt="umbra"></a>
<a href="https://github.com/wolfenrain/umbra/actions"><img src="https://raw.githubusercontent.com/wolfenrain/umbra/main/coverage_badge.svg" alt="coverage"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
</p>

---

The visual editor for shaders in Flutter.

## Packages

| Package                                                                               | Pub                                                                                                      |
| ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| [umbra_core](https://github.com/wolfenrain/umbra/tree/main/packages/umbra_core)       | [![pub package](https://img.shields.io/pub/v/umbra_core.svg)](https://pub.dev/packages/umbra_core)       |
| [umbra_flutter](https://github.com/wolfenrain/umbra/tree/main/packages/umbra_flutter) | [![pub package](https://img.shields.io/pub/v/umbra_flutter.svg)](https://pub.dev/packages/umbra_flutter) |
| [umbra_cli](https://github.com/wolfenrain/umbra/tree/main/packages/umbra_cli)         | [![pub package](https://img.shields.io/pub/v/umbra_cli.svg)](https://pub.dev/packages/umbra_cli)         |

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

## Documentation

View the general documentation for writing shaders that are compatible with Umbra [here](https://github.com/wolfenrain/umbra/tree/main/docs).

The CLI documentation can be viewed [here](https://github.com/wolfenrain/umbra/tree/main/packages/umbra_cli).
