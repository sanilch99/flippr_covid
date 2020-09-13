// To parse this JSON data, do
//
//     final ConfirmedCases = ConfirmedCasesFromJson(jsonString);

import 'dart:convert';

ConfirmedCases ConfirmedCasesFromJson(String str) => ConfirmedCases.fromJson(json.decode(str));

String ConfirmedCasesToJson(ConfirmedCases data) => json.encode(data.toJson());

class ConfirmedCases {
  ConfirmedCases({
    this.success,
    this.data,
    this.lastRefreshed,
    this.lastOriginUpdate,
  });

  bool success;
  List<Datum> data;
  DateTime lastRefreshed;
  DateTime lastOriginUpdate;

  factory ConfirmedCases.fromJson(Map<String, dynamic> json) => ConfirmedCases(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    lastRefreshed: DateTime.parse(json["lastRefreshed"]),
    lastOriginUpdate: DateTime.parse(json["lastOriginUpdate"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "lastRefreshed": lastRefreshed.toIso8601String(),
    "lastOriginUpdate": lastOriginUpdate.toIso8601String(),
  };
}

class Datum {
  Datum({
    this.day,
    this.summary,
    this.regional,
  });

  DateTime day;
  Summary summary;
  List<Regional> regional;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    day: DateTime.parse(json["day"]),
    summary: Summary.fromJson(json["summary"]),
    regional: List<Regional>.from(json["regional"].map((x) => Regional.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "day": "${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}",
    "summary": summary.toJson(),
    "regional": List<dynamic>.from(regional.map((x) => x.toJson())),
  };
}

class Regional {
  Regional({
    this.loc,
    this.confirmedCasesIndian,
    this.confirmedCasesForeign,
    this.discharged,
    this.deaths,
    this.totalConfirmed,
  });

  Loc loc;
  int confirmedCasesIndian;
  int confirmedCasesForeign;
  int discharged;
  int deaths;
  int totalConfirmed;

  factory Regional.fromJson(Map<String, dynamic> json) => Regional(
    loc: locValues.map[json["loc"]],
    confirmedCasesIndian: json["confirmedCasesIndian"],
    confirmedCasesForeign: json["confirmedCasesForeign"],
    discharged: json["discharged"],
    deaths: json["deaths"],
    totalConfirmed: json["totalConfirmed"],
  );

  Map<String, dynamic> toJson() => {
    "loc": locValues.reverse[loc],
    "confirmedCasesIndian": confirmedCasesIndian,
    "confirmedCasesForeign": confirmedCasesForeign,
    "discharged": discharged,
    "deaths": deaths,
    "totalConfirmed": totalConfirmed,
  };
}

enum Loc { DELHI, HARYANA, KARNATAKA, KERALA, MAHARASHTRA, PUNJAB, RAJASTHAN, TAMIL_NADU, TELENGANA, JAMMU_AND_KASHMIR, LADAKH, UTTAR_PRADESH, ANDHRA_PRADESH, UTTARAKHAND, ODISHA, PUDUCHERRY, WEST_BENGAL, CHHATTISGARH, CHANDIGARH, GUJARAT, HIMACHAL_PRADESH, MADHYA_PRADESH, BIHAR, MANIPUR, MIZORAM, ANDAMAN_AND_NICOBAR_ISLANDS, GOA, ASSAM, JHARKHAND, ARUNACHAL_PRADESH, TRIPURA, NAGALAND, MEGHALAYA, LOC_NAGALAND, LOC_JHARKHAND, LOC_MADHYA_PRADESH, DADAR_NAGAR_HAVELI, SIKKIM, DADRA_AND_NAGAR_HAVELI_AND_DAMAN_AND_DIU, TELANGANA, LOC_TELANGANA, LAKSHADWEEP }

final locValues = EnumValues({
  "Andaman and Nicobar Islands": Loc.ANDAMAN_AND_NICOBAR_ISLANDS,
  "Andhra Pradesh": Loc.ANDHRA_PRADESH,
  "Arunachal Pradesh": Loc.ARUNACHAL_PRADESH,
  "Assam": Loc.ASSAM,
  "Bihar": Loc.BIHAR,
  "Chandigarh": Loc.CHANDIGARH,
  "Chhattisgarh": Loc.CHHATTISGARH,
  "Dadar Nagar Haveli": Loc.DADAR_NAGAR_HAVELI,
  "Dadra and Nagar Haveli and Daman and Diu": Loc.DADRA_AND_NAGAR_HAVELI_AND_DAMAN_AND_DIU,
  "Delhi": Loc.DELHI,
  "Goa": Loc.GOA,
  "Gujarat": Loc.GUJARAT,
  "Haryana": Loc.HARYANA,
  "Himachal Pradesh": Loc.HIMACHAL_PRADESH,
  "Jammu and Kashmir": Loc.JAMMU_AND_KASHMIR,
  "Jharkhand": Loc.JHARKHAND,
  "Karnataka": Loc.KARNATAKA,
  "Kerala": Loc.KERALA,
  "Ladakh": Loc.LADAKH,
  "Lakshadweep": Loc.LAKSHADWEEP,
  "Jharkhand#": Loc.LOC_JHARKHAND,
  "Madhya Pradesh#": Loc.LOC_MADHYA_PRADESH,
  "Nagaland#": Loc.LOC_NAGALAND,
  "Telangana***": Loc.LOC_TELANGANA,
  "Madhya Pradesh": Loc.MADHYA_PRADESH,
  "Maharashtra": Loc.MAHARASHTRA,
  "Manipur": Loc.MANIPUR,
  "Meghalaya": Loc.MEGHALAYA,
  "Mizoram": Loc.MIZORAM,
  "Nagaland": Loc.NAGALAND,
  "Odisha": Loc.ODISHA,
  "Puducherry": Loc.PUDUCHERRY,
  "Punjab": Loc.PUNJAB,
  "Rajasthan": Loc.RAJASTHAN,
  "Sikkim": Loc.SIKKIM,
  "Tamil Nadu": Loc.TAMIL_NADU,
  "Telangana": Loc.TELANGANA,
  "Telengana": Loc.TELENGANA,
  "Tripura": Loc.TRIPURA,
  "Uttarakhand": Loc.UTTARAKHAND,
  "Uttar Pradesh": Loc.UTTAR_PRADESH,
  "West Bengal": Loc.WEST_BENGAL
});

class Summary {
  Summary({
    this.total,
    this.confirmedCasesIndian,
    this.confirmedCasesForeign,
    this.discharged,
    this.deaths,
    this.confirmedButLocationUnidentified,
  });

  int total;
  int confirmedCasesIndian;
  int confirmedCasesForeign;
  int discharged;
  int deaths;
  int confirmedButLocationUnidentified;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    total: json["total"],
    confirmedCasesIndian: json["confirmedCasesIndian"],
    confirmedCasesForeign: json["confirmedCasesForeign"],
    discharged: json["discharged"],
    deaths: json["deaths"],
    confirmedButLocationUnidentified: json["confirmedButLocationUnidentified"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "confirmedCasesIndian": confirmedCasesIndian,
    "confirmedCasesForeign": confirmedCasesForeign,
    "discharged": discharged,
    "deaths": deaths,
    "confirmedButLocationUnidentified": confirmedButLocationUnidentified,
  };
}

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
