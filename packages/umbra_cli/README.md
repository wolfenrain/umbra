# umbra_cli

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

---

CLI interface for Umbra.

## Installing

```sh
dart pub global activate umbra_cli
```

## Commands

#### `umbra-cli generate`

Generate files based on a given shader file:

TODO: gif here

##### Usage

```sh
# Generate the raw GLSL shader based on the given shader file
umbra-cli generate raw ./shaders/simple.glsl --output ./shaders/simple_raw.glsl

# Generate a useable SPIRV file for Flutter based on the given shader file
umbra-cli generate spirv ./shaders/simple.glsl --output ./assets/shaders

# Generate a strongly typed Dart file based on the given shader file
umbra-cli generate dart ./shaders/simple.glsl --output ./lib/shaders
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis