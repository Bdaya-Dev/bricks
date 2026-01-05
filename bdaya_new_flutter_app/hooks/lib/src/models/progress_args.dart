/// Arguments for the [Progress.run] method.
///
/// The [executable] argument is the executable to run. The [args] argument
/// are the arguments to pass to the executable. The [label] argument is the
/// label to display while the process is running. The
/// [workingDirectory] argument is the directory to run the process in.
///
/// This class is immutable.
class ProgressArgs {
  final String executable;
  final List<String> args;
  final String label;
  final String workingDirectory;

  const ProgressArgs({
    required this.executable,
    required this.args,
    required this.label,
    required this.workingDirectory,
  });
}
