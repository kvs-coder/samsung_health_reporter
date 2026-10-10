import 'package:samsung_health_reporter/samsung_health_reporter.dart';

import '../bloc/bloc.dart';
import 'catalog_bloc.dart';

/// Prepares the demo when it starts
sealed class SetupEvent {
  const SetupEvent();
}

/// Checks that Samsung Health is installed
final class SetupStarted extends SetupEvent {
  const SetupStarted();
}

enum SetupStatus { checking, unavailable, ready, failed }

class SetupState {
  const SetupState(this.status, this.message);

  final SetupStatus status;
  final String message;
}

/// Samsung Health asks for permissions from the Manager rows, so setup only
/// checks that it is installed.
class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc({Future<bool> Function()? isAvailable})
      : _isAvailable = isAvailable ?? SamsungHealthReporter.isAvailable,
        super(
            const SetupState(SetupStatus.checking, 'Checking Samsung Health…'));

  final Future<bool> Function() _isAvailable;

  @override
  Future<void> onEvent(SetupEvent event) async {
    switch (event) {
      case SetupStarted():
        await _start();
    }
  }

  Future<void> _start() async {
    try {
      emit(
        await _isAvailable()
            ? const SetupState(
                SetupStatus.ready,
                'Samsung Health is available. Grant permissions with requestPermissions',
              )
            : const SetupState(
                SetupStatus.unavailable,
                'Samsung Health is not installed on this device',
              ),
      );
    } catch (error) {
      emit(SetupState(SetupStatus.failed, CatalogBloc.describe(error)));
    }
  }
}
