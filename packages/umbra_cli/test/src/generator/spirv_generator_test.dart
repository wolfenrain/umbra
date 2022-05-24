// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:umbra/umbra.dart';
import 'package:umbra_cli/src/cmd/cmd.dart';
import 'package:umbra_cli/src/generators/spirv_generator.dart';

class _MockCmd extends Mock implements Cmd {}

class _MockDirectory extends Mock implements Directory {}

class _MockFile extends Mock implements File {}

void main() {
  group('SpirvGenerator', () {
    late Cmd cmd;
    late Directory dataDirectory;
    late Directory tmpDirectory;
    late Directory createdDirectory;

    setUp(() {
      cmd = _MockCmd();
      dataDirectory = _MockDirectory();
      tmpDirectory = _MockDirectory();
      createdDirectory = _MockDirectory();

      when(() => dataDirectory.path).thenReturn('data');

      when(tmpDirectory.createTempSync).thenReturn(createdDirectory);
      when(() => tmpDirectory.path).thenReturn('temp');
      when(() => createdDirectory.path).thenReturn('temp/created');
    });

    test('generate a SPIR-V binary', () async {
      final inputFile = _MockFile();
      final outputFile = _MockFile();
      when(() => inputFile.path).thenReturn('temp/created/raw.glsl');
      when(() => outputFile.path).thenReturn('temp/created/spirv');
      when(() => inputFile.writeAsBytesSync(any())).thenReturn(null);
      when(outputFile.readAsBytesSync).thenReturn(
        Uint8List.fromList([3, 2, 1]),
      );
      when(() => cmd.start(any(), any())).thenAnswer((_) async {
        return ProcessResult(
          1,
          0,
          Stream<List<int>>.fromIterable([]),
          Stream<List<int>>.fromIterable([]),
        );
      });

      await IOOverrides.runZoned(
        () async {
          final specification = ShaderSpecification.parse('spirv', [
            'vec4 fragment(in vec2 uv, in vec2 fragCoord) {',
            '  return vec4(uv, 0.0, 1.0);',
            '}',
          ]);

          final generator = SpirvGenerator(
            specification,
            dataDirectory: dataDirectory,
            rawBytes: [1, 2, 3],
            cmd: cmd,
          );

          await generator.generate();

          verify(tmpDirectory.createTempSync).called(1);
          verify(() => inputFile.writeAsBytesSync([1, 2, 3])).called(1);

          verify(
            () => cmd.start('data/bin/glslc', [
              '--target-env=opengl',
              '-fshader-stage=fragment',
              '-o',
              'temp/created/spirv',
              'temp/created/raw.glsl',
            ]),
          ).called(1);

          verify(outputFile.readAsBytesSync).called(1);
        },
        getSystemTempDirectory: () => tmpDirectory,
        createFile: (String path) {
          switch (path) {
            case 'temp/created/raw.glsl':
              return inputFile;
            case 'temp/created/spirv':
              return outputFile;
          }
          throw UnsupportedError(path);
        },
      );
    });
  });
}
