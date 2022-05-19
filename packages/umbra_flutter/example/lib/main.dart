import 'dart:ui' as ui;

import 'package:example/widgets/noise_widget.dart';
import 'package:example/widgets/pixelation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final imageData = await rootBundle.load('assets/dash.jpeg');
  final image = await decodeImageFromList(imageData.buffer.asUint8List());

  runApp(MaterialApp(home: ExampleApp(image: image)));
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key, required this.image}) : super(key: key);

  final ui.Image image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: Center(child: RawImage(image: image))),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: NoiseWidget(image: image)),
              Expanded(child: PixelationWidget(image: image)),
            ],
          ),
        ),
      ],
    );
  }
}
