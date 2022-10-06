// To parse this JSON data, do
//
//     final marcadores = marcadoresFromMap(jsonString);

import 'dart:convert';

class Marcadores {
    Marcadores({
        required this.cui,
        required this.lat,
        required this.lng,
        this.id
    });

    String cui;
    double lat;
    double lng;
    String? id;

    factory Marcadores.fromJson(String str) => Marcadores.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Marcadores.fromMap(Map<String, dynamic> json) => Marcadores(
        cui: json["cui"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "cui": cui,
        "lat": lat,
        "lng": lng,
    };
}
