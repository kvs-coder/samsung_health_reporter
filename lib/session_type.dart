import 'exceptions.dart';

enum SessionType { stepCount }

extension SessionTypeConstant on SessionType {
  String get constant {
    switch (this) {
      case SessionType.stepCount:
        return 'com.samsung.health.step_count';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
