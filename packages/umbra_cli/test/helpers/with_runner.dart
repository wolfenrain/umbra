import 'dart:async';

import 'package:mason/mason.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:umbra_cli/src/cmd/cmd.dart';
import 'package:umbra_cli/src/platform.dart';
import 'package:umbra_cli/src/umbra_command_runner.dart';

class _MockLogger extends Mock implements Logger {}

class _MockPubUpdater extends Mock implements PubUpdater {}

class _MockCmd extends Mock implements Cmd {}

class _MockPlatform extends Mock implements Platform {}

void Function() _overridePrint(void Function(List<String>) fn) {
  return () {
    final printLogs = <String>[];
    final spec = ZoneSpecification(
      print: (_, __, ___, String msg) {
        printLogs.add(msg);
      },
    );

    return Zone.current
        .fork(specification: spec)
        .run<void>(() => fn(printLogs));
  };
}

void Function() withRunner(
  FutureOr<void> Function(
    UmbraCommandRunner commandRunner,
    Logger logger,
    Platform platform,
    Cmd cmd,
    List<String> printLogs,
  )
      runnerFn,
) {
  return _overridePrint((printLogs) async {
    final logger = _MockLogger();
    final pubUpdater = _MockPubUpdater();
    final cmd = _MockCmd();
    final platform = _MockPlatform();
    final progressLogs = <String>[];
    final commandRunner = UmbraCommandRunner(
      logger: logger,
      pubUpdater: pubUpdater,
      cmd: cmd,
      platform: platform,
    );

    when(() => logger.progress(any())).thenReturn(
      ([_]) {
        if (_ != null) progressLogs.add(_);
      },
    );
    when(
      () => pubUpdater.isUpToDate(
        packageName: any(named: 'packageName'),
        currentVersion: any(named: 'currentVersion'),
      ),
    ).thenAnswer((_) => Future.value(true));

    await runnerFn(commandRunner, logger, platform, cmd, printLogs);
  });
}
