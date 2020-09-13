import 'dart:convert';
import 'package:flippr_covid/models/ConfirmedCases.dart';
import 'package:flippr_covid/models/Contacts.dart';
import 'package:flippr_covid/models/Hospital.dart';
import 'package:flippr_covid/models/MedicalCollege.dart';
import 'package:flippr_covid/models/Notifications.dart';
import 'package:flippr_covid/models/PatientData.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

/************************ ConfirmedCases API Work ******************************************/

Future<ConfirmedCases> getConfirmedCases() async {
  final response = await http
      .get('https://api.rootnet.in/covid19-in/stats/history');

  print("getConfirmedCases  = " +
      response.request.toString() +
      " " +
      response.body);

  if (response.body != null) {
    Map<String, dynamic> data = json.decode(response.body);

    return ConfirmedCases.fromJson(data);
  } else {
    throw Exception('Failed to load album');
  }
}


/************************ MedicalCollege API Work ******************************************/

Future<MedicalCollege> getMedicalColleges() async {
  final response = await http
      .get('https://api.rootnet.in/covid19-in/hospitals/medical-colleges');

  print("getMedicalColleges  = " +
      response.request.toString() +
      " " +
      response.body);

  if (response.body != null) {
    Map<String, dynamic> data = json.decode(response.body);

    return MedicalCollege.fromJson(data);
  } else {
    throw Exception('Failed to load album');
  }
}

/************************ Hospitals API Work ******************************************/

Future<Hospital> getHospitals() async {
  final response = await http
      .get('https://api.rootnet.in/covid19-in/hospitals/beds');

  print("getHospitals  = " +
      response.request.toString() +
      " " +
      response.body);

  if (response.body != null) {
    Map<String, dynamic> data = json.decode(response.body);

    return Hospital.fromJson(data);
  } else {
    throw Exception('Failed to load album');
  }
}

/************************ Notification API Work ******************************************/

Future<Notifications> getNotifications() async {
  final response = await http
      .get('https://api.rootnet.in/covid19-in/notifications');

  print("getNotifications  = " +
      response.request.toString() +
      " " +
      response.body);

  if (response.body != null) {
    Map<String, dynamic> data = json.decode(response.body);

    return Notifications.fromJson(data);
  } else {
    throw Exception('Failed to load album');
  }
}

/************************ Contacts API Work ******************************************/

Future<Contacts> getContacts() async {
  final response = await http
      .get('https://api.rootnet.in/covid19-in/contacts');

  print("getContacts  = " +
      response.request.toString() +
      " " +
      response.body);

  if (response.body != null) {
    Map<String, dynamic> data = json.decode(response.body);

    return Contacts.fromJson(data);
  } else {
    throw Exception('Failed to load album');
  }
}

/******************* PatientData API **********************************/
Future<String> _loadPatientAsset() async {
  return await rootBundle.loadString('assets/csvjson.json');
}

Future<PatientData> loadPatient() async {
  String jsonString = await _loadPatientAsset();
  final jsonResponse = json.decode(jsonString);
  return new PatientData.fromJson(jsonResponse);
}
