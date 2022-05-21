# Uniforms

Uniforms are the input values for shaders. These allow you to customize your shader on the go but if you want to use them
in Flutter you have to lay out each uniform by an index:

```glsl
layout (location = 0) uniform vec2 value;
layout (location = 1) uniform vec2 value;
```

Failing to do so correctly will throw a runtime error and if you pass the values in the wrong order to the shader it will 
also fail. 

We briefly touched on the [Umbra Shader Abstraction](https://github.com/wolfenrain/umbra/tree/main/docs/shader-specifications/1-shaders.md#umbra-shader-abstraction), 
the abstraction also simplifies writing uniforms for your shader. You only have to define the `uniform <type> <name>` part in 
your shader and Umbra will then make sure they get properly laid out when generating the raw GLSL shader for the SPIR-V binary.

An example of writing a shader with uniforms looks like this:

```glsl
uniform float time;

vec4 fragment(in vec2 uv, in vec2 fragCoord) {
    return vec4(abs(sin(time)), 0.0, 0.0, 1.0);
}
```

The `time` uniform would be laid out correctly and the generated Dart file will have an named parameter called `time` with the 
type `double`.

You can also use `vec2`, `vec3` and `vec4` types for your uniforms. Each will be represented in Dart by either `Vector2`, `Vector3` 
or a `Vector4`.

For a more information on uniforms check out [The Book Of Shaders, Uniforms section](https://thebookofshaders.com/03/).

## Sampling textures

In Flutter we can also sample textures in shaders, we define a uniform of the type `sampler2D` and use that to get color values 
from an image. 

```glsl
uniform sampler2D image;

vec4 fragment(in vec2 uv, in vec2 fragCoord) {
    return texture(image, uv);
}
```

This shader will generate a Dart file that has a named parameter called `image` which has the type `Image`. The shader is then 
able to sample that image and output the color of each pixel on whatever we want to render. 

Keep in mind that sampling happens in normalized space (0..1), this is why we use the `uv` as it is the normalized value of the pixel 
coordinate.
