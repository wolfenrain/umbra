import 'dart:async';
import 'dart:ui' as ui;

import 'package:example/shaders/pixelation.dart';
import 'package:flutter/material.dart';

class PixelationWidget extends StatefulWidget {
  const PixelationWidget({Key? key, required this.image}) : super(key: key);

  final ui.Image image;

  @override
  State<PixelationWidget> createState() => _PixelationWidgetState();
}

class _PixelationWidgetState extends State<PixelationWidget> {
  late Future<Pixelation> pixelation;

  late Timer timer;

  double pixelSize = 0;

  double increment = 1;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        pixelSize += increment;
        if (pixelSize == 24 || pixelSize == 0) {
          increment *= -1;
          pixelSize += increment;
        }
      });
    });

    pixelation = Pixelation.compile();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pixelation>(
      future: pixelation,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading');
        }
        final pixelation = snapshot.data!;

        return ShaderMask(
          blendMode: ui.BlendMode.src,
          shaderCallback: (bounds) {
            return pixelation.shader(
              image: widget.image,
              pixelSize: pixelSize,
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
