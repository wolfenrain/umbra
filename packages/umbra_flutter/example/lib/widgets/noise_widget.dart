import 'dart:async';
import 'dart:ui' as ui;

import 'package:example/widgets/noise.dart';
import 'package:flutter/material.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class NoiseWidget extends StatefulWidget {
  const NoiseWidget({Key? key, required this.image}) : super(key: key);

  final ui.Image image;

  @override
  State<NoiseWidget> createState() => _NoiseWidgetState();
}

class _NoiseWidgetState extends State<NoiseWidget> {
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
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Noise(
      image: widget.image,
      time: delta,
      scale: Vector2(0.3, 3.5),
      amplifier: 20,
      frequency: Vector2.all(30),
    );
  }
}
