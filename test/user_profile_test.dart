import 'package:flutter_test/flutter_test.dart';
import 'package:samsung_health_reporter/model/payload/user_profile.dart';
import 'package:samsung_health_reporter/model/type/gender.dart';

import 'fixtures.dart' as fixtures;

void main() {
  test('user_profile_parses_every_field', () {
    final sut = UserProfile.fromJson(fixtures.userProfile);
    expect(sut.nickname, 'kvs');
    expect(sut.gender, Gender.male);
    expect(sut.dateOfBirth, '1990-01-01');
    expect(sut.height, 180.0);
    expect(sut.weight, 75.5);
  });

  test('user_profile_round_trips', () {
    final sut = UserProfile.fromJson(fixtures.userProfile);
    expect(sut.map['gender'], 'GENDER_MALE');
    expect(UserProfile.fromJson(sut.map), sut);
  });

  test('empty_user_profile_parses', () {
    final sut = UserProfile.fromJson({});
    expect(sut, const UserProfile());
    expect(sut.gender, isNull);
    expect(sut.height, isNull);
  });
}
