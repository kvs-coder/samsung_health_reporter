import '../../exceptions.dart';
import 'value_enum.dart';

/// Equivalent of [ExerciseType]
/// from [SamsungHealthReporter] https://github.com/kvs-coder/SamsungHealthReporter
///
/// A predefined exercise type; use [ExerciseType.other] with a custom title for anything else.
///
/// [value] is the Kotlin constant name the JSON carries.
///
/// Has factory methods [ExerciseTypeFactory.from] and [ExerciseTypeFactory.tryFrom]
/// creating from the [value].
///
enum ExerciseType implements ValueEnum {
  undefined('UNDEFINED'),
  other('OTHER'),
  walking('WALKING'),
  running('RUNNING'),
  stairClimbing('STAIR_CLIMBING'),
  trackRunning('TRACK_RUNNING'),
  baseball('BASEBALL'),
  softball('SOFTBALL'),
  cricket('CRICKET'),
  golf('GOLF'),
  bowling('BOWLING'),
  hockey('HOCKEY'),
  rugby('RUGBY'),
  basketball('BASKETBALL'),
  soccer('SOCCER'),
  handball('HANDBALL'),
  americanFootball('AMERICAN_FOOTBALL'),
  volleyball('VOLLEYBALL'),
  beachVolleyball('BEACH_VOLLEYBALL'),
  squash('SQUASH'),
  tennis('TENNIS'),
  badminton('BADMINTON'),
  tableTennis('TABLE_TENNIS'),
  racquetball('RACQUETBALL'),
  boxing('BOXING'),
  martialArts('MARTIAL_ARTS'),
  ballet('BALLET'),
  dancing('DANCING'),
  ballroomDancing('BALLROOM_DANCING'),
  pilates('PILATES'),
  yoga('YOGA'),
  stretching('STRETCHING'),
  jumpRope('JUMP_ROPE'),
  hulaHooping('HULA_HOOPING'),
  pushUps('PUSH_UPS'),
  pullUps('PULL_UPS'),
  sitUps('SIT_UPS'),
  circuitTraining('CIRCUIT_TRAINING'),
  mountainClimbers('MOUNTAIN_CLIMBERS'),
  jumpingJacks('JUMPING_JACKS'),
  burpees('BURPEES'),
  benchPress('BENCH_PRESS'),
  squats('SQUATS'),
  lunges('LUNGES'),
  legPresses('LEG_PRESSES'),
  legExtensions('LEG_EXTENSIONS'),
  legCurls('LEG_CURLS'),
  backExtensions('BACK_EXTENSIONS'),
  latPulldowns('LAT_PULLDOWNS'),
  deadlifts('DEADLIFTS'),
  shoulderPresses('SHOULDER_PRESSES'),
  frontRaises('FRONT_RAISES'),
  lateralRaises('LATERAL_RAISES'),
  crunch('CRUNCH'),
  legRaises('LEG_RAISES'),
  plank('PLANK'),
  armCurls('ARM_CURLS'),
  armExtensions('ARM_EXTENSIONS'),
  skaters('SKATERS'),
  highKnees('HIGH_KNEES'),
  inlineSkating('INLINE_SKATING'),
  hangGliding('HANG_GLIDING'),
  archery('ARCHERY'),
  horsebackRiding('HORSEBACK_RIDING'),
  biking('BIKING'),
  flyingDisc('FLYING_DISC'),
  rollerSkating('ROLLER_SKATING'),
  aerobics('AEROBICS'),
  hiking('HIKING'),
  rockClimbing('ROCK_CLIMBING'),
  backpacking('BACKPACKING'),
  mountainBiking('MOUNTAIN_BIKING'),
  orienteering('ORIENTEERING'),
  poolSwimming('POOL_SWIMMING'),
  aquaAerobics('AQUA_AEROBICS'),
  canoeing('CANOEING'),
  sailing('SAILING'),
  scubaDiving('SCUBA_DIVING'),
  snorkeling('SNORKELING'),
  kayaking('KAYAKING'),
  kitesurfing('KITESURFING'),
  rafting('RAFTING'),
  rowing('ROWING'),
  windsurfing('WINDSURFING'),
  yachting('YACHTING'),
  waterSkiing('WATER_SKIING'),
  stepMachine('STEP_MACHINE'),
  weightMachine('WEIGHT_MACHINE'),
  stationaryBiking('STATIONARY_BIKING'),
  rowingMachine('ROWING_MACHINE'),
  treadmill('TREADMILL'),
  elliptical('ELLIPTICAL'),
  stairClimbingMachine('STAIR_CLIMBING_MACHINE'),
  crossCountrySkiing('CROSS_COUNTRY_SKIING'),
  skiing('SKIING'),
  iceDancing('ICE_DANCING'),
  iceSkating('ICE_SKATING'),
  iceHockey('ICE_HOCKEY'),
  snowboarding('SNOWBOARDING'),
  alpineSkiing('ALPINE_SKIING'),
  snowshoeing('SNOWSHOEING'),
  triathlon('TRIATHLON'),
  duathlon('DUATHLON'),
  aquathlon('AQUATHLON'),
  aquabike('AQUABIKE'),
  crossTriathlon('CROSS_TRIATHLON'),
  crossDuathlon('CROSS_DUATHLON'),

  /// `BREAK`; `break` is a reserved word in Dart
  exerciseBreak('BREAK'),
  coolDown('COOL_DOWN'),
  warmUp('WARM_UP'),
  transition('TRANSITION'),
  zumba('ZUMBA'),
  openWaterSwimming('OPEN_WATER_SWIMMING');

  const ExerciseType(this.value);

  /// The Kotlin constant name, e.g. `OTHER`
  @override
  final String value;
}

extension ExerciseTypeFactory on ExerciseType {
  /// Finds the case by its [ExerciseType.value].
  /// Throws an [InvalidValueException] for an unknown value.
  ///
  static ExerciseType from(String value) => valueOf(ExerciseType.values, value);

  /// The [from] exception handling
  ///
  static ExerciseType? tryFrom(String value) =>
      tryValueOf(ExerciseType.values, value);
}
