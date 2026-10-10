import 'payload.dart';
import '../decorator/extensions.dart';
import '../type/gender.dart';

/// Equivalent of [UserProfile]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// The user's Samsung Health profile. Read-only.
///
/// Supports [map] representation.
///
/// Has a [UserProfile.fromJson] constructor
/// to create instances from JSON payload coming from Android native code.
///
class UserProfile with Payload {
  const UserProfile({
    this.nickname,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.weight,
  });

  /// The nickname
  final String? nickname;

  /// The gender
  final Gender? gender;

  /// The date of birth, as Samsung Health stores it
  final String? dateOfBirth;

  /// Height in centimeters
  final double? height;

  /// Weight in kilograms
  final double? weight;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'nickname': nickname,
        'gender': gender?.value,
        'dateOfBirth': dateOfBirth,
        'height': height,
        'weight': weight,
      };

  /// General constructor from JSON payload
  ///
  UserProfile.fromJson(Map<String, dynamic> json)
      : nickname = json['nickname'],
        gender =
            json['gender'] == null ? null : GenderFactory.from(json['gender']),
        dateOfBirth = json['dateOfBirth'],
        height = tryParseDouble(json['height']),
        weight = tryParseDouble(json['weight']);
}
