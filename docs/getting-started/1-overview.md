# Overview

Umbra is a CLI and visual editor (WIP) for writing shaders in Flutter. It comes with a abstraction on top of the 
Flutter API to make the lives of developers that want to write shaders easier. The main goal therefore is to make writing 
shaders in Flutter easier, faster and overal more enjoyable.

## Motivation

Currently the developer has to undertake a few manual steps to create a shader and then getting it into Flutter. The 
[SPIR-V](https://github.com/flutter/engine/tree/main/lib/spirv) library that Flutter uses also comes with a few constraints 
that the developer has to take into account. This makes it difficult for the developer to quickly write a shader and test it.

Umbra automates the steps the developer has to take and it adds an abstraction on top of the existing Flutter API to ensure 
a strongly typed interface that removes or hides away some of the constraints that Flutter enforces. This in turn allows for a more 
streamlined experience for the developer. For more information on this abstraction see the [Shader Specifications](https://github.com/wolfenrain/umbra/tree/main/docs/shader-specifications)
