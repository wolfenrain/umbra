# umbra_core

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Core library for Umbra.

## Updating fixtures

The shader fixtures in `test/fixtures/shaders` are based on the shader files in `example/shaders`, 
so to update a fixture you can use the following command:

```shell
umbra-cli generate raw examples/shaders/simple.glsl --type shader --output test/fixtures/shaders/simple.glsl
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis