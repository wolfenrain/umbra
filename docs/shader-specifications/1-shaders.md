# Shaders

A shader is a set of instructions that is executed for every single pixel on the screen. Flutter has support for shaders 
through the [SPIR-V](https://github.com/flutter/engine/tree/main/lib/spirv) library. But this library comes with a set of constraints, 
these constraints can make it difficult for developers that are not yet familiar with shaders. And on top of that the API that Flutter 
provides is not strongly typed and Flutter expects the user of the shader to know exactly in which order the data has to be passed to the 
shader.

And if you wish to write your shader in [GLSL](https://www.khronos.org/opengl/wiki/OpenGL_Shading_Language) you need to manually compile 
the shader to a SPIR-V binary through a third party tool and add that binary as an asset to your application.

This is where Umbra comes in, by using Umbra's generation commands you can generate strongly typed Dart files that know exactly what 
parameters the shader need, in which order the data of those parameters should be passed and it contains the SPIR-V binary so you don't have 
to do anything related to assets. This makes it easier for users of the shader as they now have a strongly typed API that has parameters with 
which they are more familiar and it can be used immediately without any other configuration.


## Umbra Shader Abstraction

Umbra also takes away some of the constraints and complexity by adding a small abstraction on top of the raw GLSL shader. You only have to write 
your shader code and Umbra will generate the necessary raw GLSL shader that will be used to compile the SPIR-V binary. 

The abstraction is as followed, it expects a function called `fragment` that receives a `vec2` for the normalized pixel position (0..1), we call 
this the [UV](https://en.wikipedia.org/wiki/UV_mapping) and a `vec2` of the real pixel position. The function then returns a `vec4` which will be 
used as the color for the current pixel.

So a simple shader that follows this abstraction looks like this:

```glsl
vec4 fragment(in vec2 uv, in vec2 fragCoord) {
    return vec4(uv.x, uv.y, 0.0, 1.0);
}
```

As you can see it has a single function called `fragment`. Which receives an input `uv` value and an input `fragCoord` value.

It uses the `uv` value to return a color that will map the pixel to a redish/greenish color depending on the position.

The result of this shader is this:

![simple_uv_map](https://raw.githubusercontent.com/wolfenrain/umbra/main/assets/simple_uv_map.png)

## Further Reading

For a nice introduction on shaders check out [The Book Of Shaders](https://thebookofshaders.com/).

For more information on passing data to shaders, see the [Uniform](https://github.com/wolfenrain/umbra/tree/main/docs/shader-specifications/2-uniforms.md) documentation.
