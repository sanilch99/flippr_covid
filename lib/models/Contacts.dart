// To parse this JSON data, do
//
//     final contacts = contactsFromJson(jsonString);

import 'dart:convert';

Contacts contactsFromJson(String str) => Contacts.fromJson(json.decode(str));

String contactsToJson(Contacts data) => json.encode(data.toJson());

class Contacts {
  Contacts({
    this.success,
    this.data,
    this.lastRefreshed,
    this.lastOriginUpdate,
  });

  bool success;
  Data data;
  DateTime lastRefreshed;
  DateTime lastOriginUpdate;

  factory Contacts.fromJson(Map<String, dynamic> json) => Contacts(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    lastRefreshed: DateTime.parse(json["lastRefreshed"]),
    lastOriginUpdate: DateTime.parse(json["lastOriginUpdate"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "lastRefreshed": lastRefreshed.toIso8601String(),
    "lastOriginUpdate": lastOriginUpdate.toIso8601String(),
  };
}

class Data {
  Data({
    this.contacts,
  });

  ContactsClass contacts;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    contacts: ContactsClass.fromJson(json["contacts"]),
  );

  Map<String, dynamic> toJson() => {
    "contacts": contacts.toJson(),
  };
}

class ContactsClass {
  ContactsClass({
    this.primary,
    this.regional,
  });

  Primary primary;
  List<Regional> regional;

  factory ContactsClass.fromJson(Map<String, dynamic> json) => ContactsClass(
    primary: Primary.fromJson(json["primary"]),
    regional: List<Regional>.from(json["regional"].map((x) => Regional.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "primary": primary.toJson(),
    "regional": List<dynamic>.from(regional.map((x) => x.toJson())),
  };
}

class Primary {
  Primary({
    this.number,
    this.numberTollfree,
    this.email,
    this.twitter,
    this.facebook,
    this.media,
  });

  String number;
  String numberTollfree;
  String email;
  String twitter;
  String facebook;
  List<String> media;

  factory Primary.fromJson(Map<String, dynamic> json) => Primary(
    number: json["number"],
    numberTollfree: json["number-tollfree"],
    email: json["email"],
    twitter: json["twitter"],
    facebook: json["facebook"],
    media: List<String>.from(json["media"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "number-tollfree": numberTollfree,
    "email": email,
    "twitter": twitter,
    "facebook": facebook,
    "media": List<dynamic>.from(media.map((x) => x)),
  };
}

class Regional {
  Regional({
    this.loc,
    this.number,
  });

  String loc;
  String number;

  factory Regional.fromJson(Map<String, dynamic> json) => Regional(
    loc: json["loc"],
    number: json["number"],
  );

  Map<String, dynamic> toJson() => {
    "loc": loc,
    "number": number,
  };
}
