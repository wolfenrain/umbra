<h1 align="center">
umbra_core
</h1>

<p align="center">
<a href="https://pub.dev/packages/umbra_core"><img src="https://img.shields.io/pub/v/umbra_core.svg" alt="Pub"></a>
<a href="https://github.com/wolfenrain/umbra/actions"><img src="https://github.com/wolfenrain/umbra/workflows/umbra_core/badge.svg" alt="umbra_core"></a>
<a href="https://github.com/wolfenrain/umbra/actions"><img src="https://raw.githubusercontent.com/wolfenrain/umbra/main/packages/umbra_core/coverage_badge.svg" alt="coverage"></a>
<a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="style: very good analysis"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://github.com/felangel/mason"><img src="https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge" alt="Powered by Mason"></a>
</p>

---

Core library for Umbra.

## Updating fixtures

The shader fixtures in `test/fixtures/shaders` are based on the shader files in `example/shaders`, 
so to update a fixture you can use the following command:

```shell
umbra generate raw examples/shaders/simple.glsl --type shader --output test/fixtures/shaders/simple.glsl
```

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis