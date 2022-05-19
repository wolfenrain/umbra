import 'dart:async';
import 'dart:ui' as ui;

import 'package:example/shaders/noise.dart';
import 'package:flutter/material.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class NoiseWidget extends StatefulWidget {
  const NoiseWidget({Key? key, required this.image}) : super(key: key);

  final ui.Image image;

  @override
  State<NoiseWidget> createState() => _NoiseWidgetState();
}

class _NoiseWidgetState extends State<NoiseWidget> {
  late Future<Noise> noise;

  late Timer timer;

  double delta = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        delta += 1 / 60;
      });
    });

    noise = Noise.compile();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Noise>(
      future: noise,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading');
        }
        final noise = snapshot.data!;

        return ShaderMask(
          blendMode: ui.BlendMode.src,
          shaderCallback: (bounds) {
            return noise.shader(
              image: widget.image,
              time: delta,
              scale: Vector2(0.3, 3.5),
              amplifier: 20,
              frequency: Vector2.all(30),
              resolution: Size(bounds.size.width, bounds.size.height),
            );
          },
          child: FittedBox(
            child: Container(
              color: Colors.transparent,
              width: widget.image.width.toDouble(),
              height: widget.image.height.toDouble(),
            ),
          ),
        );
      },
    );
  }
}
