// JSON payloads shaped like SamsungHealthReporter 1.0.0 encodes them:
// a sample carries its `type` discriminator, null fields are left out,
// lists with defaults are present, Kotlin Floats are encoded with a fraction.

const start = 1760000000000;
const end = 1760003600000;
const offset = 7200;

const dataSource = {'appId': 'com.example', 'deviceId': 'device-1'};

const heartRate = {
  'type': 'heart_rate',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'heartRate': 72.0,
    'min': 60.0,
    'max': 90.0,
    'series': [
      {
        'heartRate': 70.0,
        'min': 65.0,
        'max': 75.0,
        'startTimestamp': start,
        'endTimestamp': start + 60000,
      },
    ],
  },
  'uid': 'uid-heart-rate',
  'clientDataId': 'client-1',
  'zoneOffsetSeconds': offset,
  'dataSource': dataSource,
};

const bloodOxygen = {
  'type': 'blood_oxygen',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'oxygenSaturation': 97.0,
    'min': 95.0,
    'max': 99.0,
    'series': [
      {
        'oxygenSaturation': 96.0,
        'min': 95.0,
        'max': 98.0,
        'startTimestamp': start,
        'endTimestamp': start + 60000,
      },
    ],
  },
  'uid': 'uid-blood-oxygen',
  'zoneOffsetSeconds': offset,
  'dataSource': dataSource,
};

const bloodPressure = {
  'type': 'blood_pressure',
  'startTimestamp': start,
  'harmonized': {
    'systolic': 120.0,
    'diastolic': 80.0,
    'mean': 93.3,
    'pulseRate': 70,
    'medicationTaken': false,
  },
  'uid': 'uid-blood-pressure',
};

const bloodGlucose = {
  'type': 'blood_glucose',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'glucoseLevel': 5.5,
    'mealStatus': 'AFTER_MEAL',
    'measurementType': 'WHOLE_BLOOD',
    'sampleSource': 'CAPILLARY',
    'insulinInjected': 2.5,
    'mealTimestamp': start - 3600000,
    'medicationTaken': true,
    'series': [
      {'glucose': 5.4, 'timestamp': start + 300000},
    ],
  },
  'uid': 'uid-blood-glucose',
};

const bodyComposition = {
  'type': 'body_composition',
  'startTimestamp': start,
  'harmonized': {
    'weight': 75.5,
    'height': 180.0,
    'bodyFat': 18.5,
    'bodyFatMass': 14.0,
    'bodyMassIndex': 23.3,
    'fatFree': 81.5,
    'fatFreeMass': 61.5,
    'muscleMass': 45.0,
    'skeletalMuscle': 40.0,
    'skeletalMuscleMass': 30.2,
    'totalBodyWater': 44.1,
    'basalMetabolicRate': 1700,
  },
  'uid': 'uid-body-composition',
};

const bodyTemperature = {
  'type': 'body_temperature',
  'startTimestamp': start,
  'harmonized': {'temperature': 36.6},
  'uid': 'uid-body-temperature',
};

const skinTemperature = {
  'type': 'skin_temperature',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'skinTemperature': 33.5,
    'min': 33.0,
    'max': 34.0,
    'series': [
      {
        'skinTemperature': 33.4,
        'min': 33.1,
        'max': 33.8,
        'startTimestamp': start,
        'endTimestamp': start + 60000,
      },
    ],
  },
  'uid': 'uid-skin-temperature',
};

const exerciseSession = {
  'exerciseType': 'RUNNING',
  'startTimestamp': start,
  'endTimestamp': end,
  'durationMillis': 3600000,
  'calories': 500.0,
  'customTitle': 'Morning run',
  'comment': 'Felt good',
  'distance': 10000.0,
  'count': 9000,
  'countType': 'STRIDE',
  'altitudeGain': 50.0,
  'altitudeLoss': 45.0,
  'maxAltitude': 120.0,
  'minAltitude': 70.0,
  'inclineDistance': 2000.0,
  'declineDistance': 1800.0,
  'maxCadence': 180.0,
  'meanCadence': 165.0,
  'maxCalorieBurnRate': 800.0,
  'meanCalorieBurnRate': 500.0,
  'maxHeartRate': 175.0,
  'meanHeartRate': 150.0,
  'minHeartRate': 90.0,
  'maxPower': 300.0,
  'meanPower': 200.0,
  'maxRpm': 90.0,
  'meanRpm': 80.0,
  'maxSpeed': 4.5,
  'meanSpeed': 2.8,
  'vo2Max': 48.5,
  'log': [
    {
      'timestamp': start + 60000,
      'heartRate': 140.0,
      'cadence': 160.0,
      'count': 150,
      'power': 190.0,
      'speed': 2.7,
    },
  ],
  'route': [
    {
      'timestamp': start + 60000,
      'latitude': 52.52,
      'longitude': 13.405,
      'altitude': 34.0,
      'accuracy': 5.0,
    },
  ],
};

const exercise = {
  'type': 'exercise',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'exerciseType': 'RUNNING',
    'sessions': [exerciseSession],
    'customTitle': 'Morning run',
  },
  'uid': 'uid-exercise',
  'zoneOffsetSeconds': offset,
  'dataSource': dataSource,
};

const floorsClimbed = {
  'type': 'floors_climbed',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {'floor': 12.0},
  'uid': 'uid-floors-climbed',
};

const sleep = {
  'type': 'sleep',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {
    'durationMillis': 3600000,
    'sessions': [
      {
        'startTimestamp': start,
        'endTimestamp': end,
        'durationMillis': 3600000,
        'stages': [
          {
            'startTimestamp': start,
            'endTimestamp': start + 1800000,
            'stage': 'LIGHT',
          },
          {
            'startTimestamp': start + 1800000,
            'endTimestamp': end,
            'stage': 'DEEP',
          },
        ],
      },
    ],
    'sleepScore': 85,
  },
  'uid': 'uid-sleep',
};

const nutrition = {
  'type': 'nutrition',
  'startTimestamp': start,
  'harmonized': {
    'title': 'Oatmeal',
    'mealType': 'BREAKFAST',
    'calories': 350.0,
    'carbohydrate': 60.0,
    'protein': 12.0,
    'totalFat': 6.0,
    'saturatedFat': 1.0,
    'monounsaturatedFat': 2.0,
    'polyunsaturatedFat': 2.5,
    'transFat': 0.1,
    'sugar': 8.0,
    'dietaryFiber': 9.0,
    'cholesterol': 5.0,
    'sodium': 120.0,
    'potassium': 300.0,
    'calcium': 150.0,
    'iron': 3.5,
    'vitaminA': 20.0,
    'vitaminC': 1.5,
  },
  'uid': 'uid-nutrition',
};

const waterIntake = {
  'type': 'water_intake',
  'startTimestamp': start,
  'harmonized': {'amount': 250.0},
  'uid': 'uid-water-intake',
};

const energyScore = {
  'type': 'energy_score',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {'score': 78.0},
  'uid': 'uid-energy-score',
};

const irregularHeartRhythmNotification = {
  'type': 'irregular_heart_rhythm_notification',
  'startTimestamp': start,
  'harmonized': {'status': 'DETECTED'},
  'uid': 'uid-irregular-heart-rhythm',
};

const sleepApnea = {
  'type': 'sleep_apnea',
  'startTimestamp': start,
  'endTimestamp': end,
  'harmonized': {'detectedSign': 'NOT_DETECTED'},
  'uid': 'uid-sleep-apnea',
};

/// Every sample fixture by its `type` identifier.
const samples = <String, Map<String, dynamic>>{
  'heart_rate': heartRate,
  'blood_oxygen': bloodOxygen,
  'blood_pressure': bloodPressure,
  'blood_glucose': bloodGlucose,
  'body_composition': bodyComposition,
  'body_temperature': bodyTemperature,
  'skin_temperature': skinTemperature,
  'exercise': exercise,
  'floors_climbed': floorsClimbed,
  'sleep': sleep,
  'nutrition': nutrition,
  'water_intake': waterIntake,
  'energy_score': energyScore,
  'irregular_heart_rhythm_notification': irregularHeartRhythmNotification,
  'sleep_apnea': sleepApnea,
};

const userProfile = {
  'nickname': 'kvs',
  'gender': 'GENDER_MALE',
  'dateOfBirth': '1990-01-01',
  'height': 180.0,
  'weight': 75.5,
};

const device = {
  'id': 'device-1',
  'type': 'WATCH',
  'manufacturer': 'Samsung',
  'model': 'SM-R960',
  'name': 'Galaxy Watch',
};

const aggregate = {
  'aggregation': 'STEPS_TOTAL',
  'startTimestamp': start,
  'endTimestamp': end,
  'value': 1234.0,
  'unit': 'count',
};

const changeSet = {
  'type': 'HEART_RATE',
  'since': start,
  'until': end,
  'upserted': [heartRate, bloodPressure],
  'deletedUids': ['uid-deleted-1', 'uid-deleted-2'],
};

const page = {
  'items': [heartRate, sleep],
  'nextPageToken': 'token-2',
};

const permissions = [
  {'type': 'HEART_RATE', 'access': 'READ'},
  {'type': 'EXERCISE_LOCATION', 'access': 'READ'},
  {'type': 'SLEEP', 'access': 'WRITE'},
];
