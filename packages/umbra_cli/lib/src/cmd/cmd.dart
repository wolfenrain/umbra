import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Abstraction for running commands via command-line.
class Cmd {
  /// Runs the specified [cmd] with the provided [args].
  Future<ProcessResult> run(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
  }) async {
    final result = await Process.run(
      cmd,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );

    if (throwOnError) {
      await _throwIfProcessFailed(result, cmd, args);
    }
    return result;
  }

  /// Runs the specified [cmd] with the provided [args].
  Future<ProcessResult> start(
    String cmd,
    List<String> args, {
    bool throwOnError = true,
    String? workingDirectory,
  }) async {
    final process = await Process.start(
      cmd,
      args,
      workingDirectory: workingDirectory,
      runInShell: true,
    );

    final exitCode = await process.exitCode;
    final result = ProcessResult(
      process.pid,
      exitCode,
      process.stdout,
      process.stderr,
    );

    if (throwOnError) {
      await _throwIfProcessFailed(result, cmd, args);
    }
    return result;
  }

  Future<void> _throwIfProcessFailed(
    ProcessResult pr,
    String process,
    List<String> args,
  ) async {
    if (pr.exitCode != 0) {
      dynamic stdout = pr.stdout;
      dynamic stderr = pr.stderr;
      if (pr.stdout is Stream<List<int>>) {
        stdout = (await (pr.stdout as Stream<List<int>>)
                .transform<String>(const Utf8Decoder())
                .toList())
            .join();
      }
      if (pr.stderr is Stream<List<int>>) {
        stderr = (await (pr.stderr as Stream<List<int>>)
                .transform<String>(const Utf8Decoder())
                .toList())
            .join();
      }
      final values = {
        'Standard out': stdout.toString().trim(),
        'Standard error': stderr.toString().trim()
      }..removeWhere((k, v) => v.isEmpty);

      var message = 'Unknown error';
      if (values.isNotEmpty) {
        message = values.entries.map((e) => '${e.key}\n${e.value}').join('\n');
      }

      throw ProcessException(process, args, message, pr.exitCode);
    }
  }
}
