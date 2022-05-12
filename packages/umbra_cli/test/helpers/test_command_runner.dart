import 'package:args/command_runner.dart';

class TestCommandRunner extends CommandRunner<int> {
  TestCommandRunner(List<Command<int>> commands)
      : super('test', 'test command runner') {
    commands.forEach(addCommand);
  }
}
