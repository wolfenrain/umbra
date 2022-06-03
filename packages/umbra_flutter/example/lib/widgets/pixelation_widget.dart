import 'dart:async';
import 'dart:ui' as ui;

import 'package:example/widgets/pixelation.dart';
import 'package:flutter/material.dart';

class PixelationWidget extends StatefulWidget {
  const PixelationWidget({Key? key, required this.image}) : super(key: key);

  final ui.Image image;

  @override
  State<PixelationWidget> createState() => _PixelationWidgetState();
}

class _PixelationWidgetState extends State<PixelationWidget> {
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
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Pixelation(
      pixelSize: pixelSize,
      image: widget.image,
    );
  }
}
