class StepCount {
  const StepCount(
    this.readResult,
  );

  final ReadResult readResult;

  Map<String, dynamic> get map => {
        'readResult': readResult.map,
      };

  StepCount.fromJson(Map<String, dynamic> json)
      : readResult = ReadResult.fromJson(json['readResult']);

  static List<StepCount> collect(List<dynamic> list) {
    final samples = <StepCount>[];
    for (final Map<String, dynamic> map in list) {
      final sample = StepCount.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}

class ReadResult {
  const ReadResult(
    this.uuid,
    this.packageName,
    this.deviceUuid,
    this.custom,
    this.createTime,
    this.updateTime,
    this.startTime,
    this.timeOffset,
    this.endTime,
    this.count,
    this.calorie,
    this.speed,
    this.distance,
    this.position,
  );
  final String uuid;

  final String packageName;
  final String deviceUuid;
  final String custom;
  final int createTime;
  final int updateTime;
  final int startTime;
  final int timeOffset;
  final int endTime;
  final Count count;
  final Calorie calorie;
  final Speed speed;
  final Distance distance;
  final Position position;

  Map<String, dynamic> get map => {
        'uuid': uuid,
        'packageName': packageName,
        'deviceUuid': deviceUuid,
        'custom': custom,
        'createTime': createTime,
        'updateTime': updateTime,
        'startTime': startTime,
        'timeOffset': timeOffset,
        'endTime': endTime,
        'count': count.map,
        'calorie': calorie.map,
        'speed': speed.map,
        'distance': distance.map,
        'position': position.map,
      };

  ReadResult.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        packageName = json['packageName'],
        deviceUuid = json['deviceUuid'],
        custom = json['custom'],
        createTime = json['createTime'],
        updateTime = json['updateTime'],
        startTime = json['startTime'],
        timeOffset = json['timeOffset'],
        endTime = json['endTime'],
        count = Count.fromJson(json['count']),
        calorie = Calorie.fromJson(json['calorie']),
        speed = Speed.fromJson(json['speed']),
        distance = Distance.fromJson(json['distance']),
        position = Position.fromJson(json['position']);
}

class Count {
  const Count(
    this.value,
    this.unit,
  );

  final int value;
  final String unit;

  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
      };

  Count.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        unit = json['unit'];
}

class Calorie {
  const Calorie(
    this.value,
    this.unit,
  );

  final num value;
  final String unit;

  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
      };

  Calorie.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        unit = json['unit'];
}

class Speed {
  const Speed(
    this.value,
    this.unit,
  );

  final num value;
  final String unit;

  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
      };

  Speed.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        unit = json['unit'];
}

class Distance {
  const Distance(
    this.value,
    this.unit,
  );

  final num value;
  final String unit;

  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
      };

  Distance.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        unit = json['unit'];
}

class Position {
  const Position(
    this.id,
    this.type,
  );

  final int id;
  final String type;

  Map<String, dynamic> get map => {
        'id': id,
        'type': type,
      };

  Position.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'];
}
