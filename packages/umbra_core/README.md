<h1 align="center">
Umbra Core
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

The core functionality for Umbra shaders which that helps Flutter developers to generate the necessary files for Flutter Shaders.

`package:umbra_core` contains all the core functionality that powers both [package:umbra_cli](https://pub.dev/packages/umbra_cli) and the [Umbra application](https://github.com/wolfenrain/umbra/tree/main/app).

```dart
import 'dart:io';

import 'package:umbra_core/umbra_core.dart';

Future<void> main() async {
    final specification = ShaderSpecification.fromFile(File('./hello_world.glsl'));
    final generator = RawGenerator(specification);

    File('./hello_world_raw.glsl').writeAsBytesSync(await generator.generate());
}
```
