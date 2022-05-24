# Next Steps

## Creating your First Shader

Now that you have the CLI installed you can create your first shader!

```bash
# 🕶️ Create your first shader
umbra create hello_world
```

This will generate the following GLSL file with the name `hello_world.glsl` in the current directory.

```glsl
vec4 fragment(in vec2 uv, in vec2 fragCoord) {
    return vec4(uv.x, uv.y, 0.0, 1.0);
}
```

As you can see it has a single function called `fragment`. Which receives a `uv`, which is the normalized pixel position, 
and it receives `fragCoord` which is the current pixel position.

The function returns a `vec4`, this represents the color value that will be used for the current pixel.

## Compiling to a Dart file

Now that we have a shader we can compile it to a Dart file.

```bash
# 📦 Compile your first shader to a Dart file
umbra generate shaders/hello_world.glsl --output lib/shaders/
```

You can then use this Dart file directly inside your Flutter app.

```dart
...

// Compile the instance.
final helloWorld = await HelloWorld.compile();

// Retrieve a shader instance.
final helloWorldShader = helloWorld.shader();

// You can then use the shader instance with something like a `ShaderMask` or `Paint` object.
final myPaint = Paint()..shader = helloWorldShader;

...
```

## What Next?

Great! You now know how to create and compile shaders using Umbra!

If you want to know more about how to write shaders, check out the [Shader Specifications](https://github.com/wolfenrain/umbra/tree/main/docs/shader-specifications) 
documentation.

It's time for you to dive deeper into the world of shaders, go check out [The Book Of Shaders](https://thebookofshaders.com) if you haven't already.

And if you are in need of a visual editor to quickly test your shaders, install the Umbra Visual Editor (WIP).
