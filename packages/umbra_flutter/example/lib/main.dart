import 'dart:async';
import 'dart:ui' as ui;

import 'package:example/shaders/noise.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final imageData = await rootBundle.load('assets/dash.jpeg');
  final image = await decodeImageFromList(imageData.buffer.asUint8List());

  runApp(MaterialApp(home: NoiseWidget(image: image)));
}

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

        return Column(
          children: [
            Expanded(child: Image.asset('assets/dash.jpeg')),
            Expanded(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return noise.shader(
                    widget.image,
                    time: delta,
                    scale: Vector2(0.3, 3.5),
                    amplifier: 20,
                    frequency: Vector2.all(30),
                    resolution: Size(bounds.size.width, bounds.size.height),
                  );
                },
                child: Container(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
