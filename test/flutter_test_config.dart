import 'dart:async';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return GoldenToolkit.runWithConfiguration(
    () async {
      await loadAppFonts();
      await testMain();
    },
    config: GoldenToolkitConfiguration(
      // Simple configuration for basic golden tests
      skipGoldenAssertion: () => false,
      // Default devices for testing
      defaultDevices: const [Device.phone],
    ),
  );
}
