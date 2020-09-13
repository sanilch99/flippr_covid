// To parse this JSON data, do
//
//     final patientData = patientDataFromJson(jsonString);

import 'dart:convert';

PatientData patientDataFromJson(String str) => PatientData.fromJson(json.decode(str));

String patientDataToJson(PatientData data) => json.encode(data.toJson());

class PatientData {
  PatientData({
    this.data,
  });

  List<Datum> data;

  factory PatientData.fromJson(Map<String, dynamic> json) => PatientData(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.patientId,
    this.reportedOn,
    this.ageEstimate,
    this.gender,
    this.state,
    this.status,
  });

  int patientId;
  String reportedOn;
  int ageEstimate;
  Gender gender;
  String state;
  Status status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    patientId: json["patientId"],
    reportedOn: json["reportedOn"],
    ageEstimate: json["ageEstimate"]==""?30:json["ageEstimate"],
    gender: genderValues.map[json["gender"]],
    state: json["state"],
    status: statusValues.map[json["status"]],
  );

  Map<String, dynamic> toJson() => {
    "patientId": patientId,
    "reportedOn": reportedOn,
    "ageEstimate": ageEstimate,
    "gender": genderValues.reverse[gender],
    "state": state,
    "status": statusValues.reverse[status],
  };
}

enum Gender { FEMALE, MALE, EMPTY }

final genderValues = EnumValues({
  "": Gender.EMPTY,
  "female": Gender.FEMALE,
  "male": Gender.MALE
});

enum Status { DECEASED }

final statusValues = EnumValues({
  "Deceased": Status.DECEASED
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
