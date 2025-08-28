import '../common.dart';

/// Splash screen should be theme/locale independent
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.child});
  final Widget? child;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _startInitialization();
  }

  void _startInitialization({bool retrying = false}) {
    // Use get_it to retrieve the InitService instance
    _initializationFuture = getIt<InitService>().init(
      context,
      retrying: retrying,
    );
  }

  void _retry() {
    setState(() => _startInitialization(retrying: true)); // Reset the future
  }

  @override
  Widget build(BuildContext context) {
    final actualChild = widget.child ?? const SizedBox.shrink();
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen(
            snapshot: snapshot,
            onRetry: _retry,
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          //if not done, show loading
          return const Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator.adaptive(),
              ],
            ),
          );
        }
        return actualChild;
      },
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;
  final AsyncSnapshot<void> snapshot;
  const ErrorScreen({
    super.key,
    required this.onRetry,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const AppLogo(),
            if (snapshot.connectionState != ConnectionState.waiting)
              Text(
                l10n.unknown_error,
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 20),

            if (snapshot.connectionState == ConnectionState.waiting)
              const CircularProgressIndicator.adaptive()
            else
              ElevatedButton(
                onPressed: onRetry,
                child: Text(l10n.retry),
              ),
          ],
        ),
      ),
    );
  }
}
