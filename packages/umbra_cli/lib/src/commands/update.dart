import 'package:mason/mason.dart' hide packageVersion;
import 'package:pub_updater/pub_updater.dart';
import 'package:umbra_cli/src/umbra_command.dart';
import 'package:umbra_cli/src/umbra_command_runner.dart';
import 'package:umbra_cli/src/version.dart';

/// {@template update_command}
/// `umbra update` command which updates umbra.
/// {@endtemplate}
class UpdateCommand extends UmbraCommand {
  /// {@macro update_command}
  UpdateCommand({
    required PubUpdater pubUpdater,
    super.logger,
    super.cmd,
    super.platform,
  }) : _pubUpdater = pubUpdater;

  final PubUpdater _pubUpdater;

  @override
  final String description = 'Update umbra.';

  @override
  final String name = 'update';

  @override
  Future<int> run() async {
    final updateCheckDone = logger.progress('Checking for updates');
    late final String latestVersion;
    try {
      latestVersion = await _pubUpdater.getLatestVersion(packageName);
    } catch (error) {
      updateCheckDone();
      logger.err('$error');
      return ExitCode.software.code;
    }
    updateCheckDone('Checked for updates');

    final isUpToDate = packageVersion == latestVersion;
    if (isUpToDate) {
      logger.info('umbra is already at the latest version.');
      return ExitCode.success.code;
    }

    final updateDone = logger.progress('Updating to $latestVersion');
    try {
      await _pubUpdater.update(packageName: packageName);
    } catch (error) {
      updateDone();
      logger.err('$error');
      return ExitCode.software.code;
    }
    updateDone('Updated to $latestVersion');

    return ExitCode.success.code;
  }
}
