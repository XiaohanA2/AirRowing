import 'package:air_rowing/generated/json/base/json_field.dart';
import 'package:air_rowing/generated/json/boat_training_entity.g.dart';
import 'dart:convert';
export 'package:air_rowing/generated/json/boat_training_entity.g.dart';

@JsonSerializable()
class BoatTrainingEntity {
	late int userId;
	late int id;
	late String trainingTime;
	late int totalDistance;
	late int totalTime;
	late int totalPace;
	late int heartRate;
	late int strokeRate;
	late String note;
	late String boatType;
	late String content;
	late String place;

	BoatTrainingEntity();

	factory BoatTrainingEntity.fromJson(Map<String, dynamic> json) => $BoatTrainingEntityFromJson(json);

	Map<String, dynamic> toJson() => $BoatTrainingEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}