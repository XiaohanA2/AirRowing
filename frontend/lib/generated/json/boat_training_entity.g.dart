import 'package:air_rowing/generated/json/base/json_convert_content.dart';
import 'package:air_rowing/boat_training_entity.dart';

BoatTrainingEntity $BoatTrainingEntityFromJson(Map<String, dynamic> json) {
  final BoatTrainingEntity boatTrainingEntity = BoatTrainingEntity();
  final int? userId = jsonConvert.convert<int>(json['userId']);
  if (userId != null) {
    boatTrainingEntity.userId = userId;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    boatTrainingEntity.id = id;
  }
  final String? trainingTime = jsonConvert.convert<String>(
      json['trainingTime']);
  if (trainingTime != null) {
    boatTrainingEntity.trainingTime = trainingTime;
  }
  final int? totalDistance = jsonConvert.convert<int>(json['totalDistance']);
  if (totalDistance != null) {
    boatTrainingEntity.totalDistance = totalDistance;
  }
  final int? totalTime = jsonConvert.convert<int>(json['totalTime']);
  if (totalTime != null) {
    boatTrainingEntity.totalTime = totalTime;
  }
  final int? totalPace = jsonConvert.convert<int>(json['totalPace']);
  if (totalPace != null) {
    boatTrainingEntity.totalPace = totalPace;
  }
  final int? heartRate = jsonConvert.convert<int>(json['heartRate']);
  if (heartRate != null) {
    boatTrainingEntity.heartRate = heartRate;
  }
  final int? strokeRate = jsonConvert.convert<int>(json['strokeRate']);
  if (strokeRate != null) {
    boatTrainingEntity.strokeRate = strokeRate;
  }
  final String? note = jsonConvert.convert<String>(json['note']);
  if (note != null) {
    boatTrainingEntity.note = note;
  }
  final String? boatType = jsonConvert.convert<String>(json['boatType']);
  if (boatType != null) {
    boatTrainingEntity.boatType = boatType;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    boatTrainingEntity.content = content;
  }
  final String? place = jsonConvert.convert<String>(json['place']);
  if (place != null) {
    boatTrainingEntity.place = place;
  }
  return boatTrainingEntity;
}

Map<String, dynamic> $BoatTrainingEntityToJson(BoatTrainingEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['userId'] = entity.userId;
  data['id'] = entity.id;
  data['trainingTime'] = entity.trainingTime;
  data['totalDistance'] = entity.totalDistance;
  data['totalTime'] = entity.totalTime;
  data['totalPace'] = entity.totalPace;
  data['heartRate'] = entity.heartRate;
  data['strokeRate'] = entity.strokeRate;
  data['note'] = entity.note;
  data['boatType'] = entity.boatType;
  data['content'] = entity.content;
  data['place'] = entity.place;
  return data;
}

extension BoatTrainingEntityExtension on BoatTrainingEntity {
  BoatTrainingEntity copyWith({
    int? userId,
    int? id,
    String? trainingTime,
    int? totalDistance,
    int? totalTime,
    int? totalPace,
    int? heartRate,
    int? strokeRate,
    String? note,
    String? boatType,
    String? content,
    String? place,
  }) {
    return BoatTrainingEntity()
      ..userId = userId ?? this.userId
      ..id = id ?? this.id
      ..trainingTime = trainingTime ?? this.trainingTime
      ..totalDistance = totalDistance ?? this.totalDistance
      ..totalTime = totalTime ?? this.totalTime
      ..totalPace = totalPace ?? this.totalPace
      ..heartRate = heartRate ?? this.heartRate
      ..strokeRate = strokeRate ?? this.strokeRate
      ..note = note ?? this.note
      ..boatType = boatType ?? this.boatType
      ..content = content ?? this.content
      ..place = place ?? this.place;
  }
}