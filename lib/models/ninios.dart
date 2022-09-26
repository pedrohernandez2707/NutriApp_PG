// To parse this JSON data, do
//
//     final ninio = ninioFromMap(jsonString);

import 'dart:convert';

class Ninio {
    Ninio({
      required this.apellidos,
      required this.fechaNacimiento,
      required this.genero,
      this.geolocalizacion,
      required this.nombres,
      this.pesoEdad,
      this.tallaEdad,
      required this.tutor,
      this.id
    });

    String apellidos;
    String fechaNacimiento;
    String genero;
    Geolocalizacion? geolocalizacion;
    String nombres;
    PesoEdad? pesoEdad;
    TallaEdad? tallaEdad;
    Tutor tutor;
    String? id;

    factory Ninio.fromJson(String str) => Ninio.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Ninio.fromMap(Map<String, dynamic> json) => Ninio(

        apellidos: json["apellidos"],
        fechaNacimiento: json["fechaNacimiento"],
        genero: json["genero"],
        //geolocalizacion: Geolocalizacion.fromMap(json["geolocalizacion"]),
        nombres: json["nombres"],
        //pesoEdad: PesoEdad.fromMap(json["pesoEdad"]),
        //tallaEdad: TallaEdad.fromMap(json["tallaEdad"]),
        tutor: Tutor.fromMap(json["tutor"]),
    );

    Map<String, dynamic> toMap() => {
        "apellidos": apellidos,
        "fechaNacimiento": fechaNacimiento,
        "genero": genero,
        "geolocalizacion": geolocalizacion?.toMap(),
        "nombres": nombres,
        "pesoEdad": pesoEdad?.toMap(),
        "tallaEdad": tallaEdad?.toMap(),
        "tutor": tutor.toMap(),
    };

    Ninio copy()=> Ninio(
      apellidos: apellidos,
      nombres: nombres,
      fechaNacimiento: fechaNacimiento,
      genero: genero,
      id: id,
      tutor: tutor
    );
}

class Geolocalizacion {
    Geolocalizacion({
        required this.lat,
        required this.lng,
    });

    double lat;
    double lng;

    factory Geolocalizacion.fromJson(String str) => Geolocalizacion.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Geolocalizacion.fromMap(Map<String, dynamic> json) => Geolocalizacion(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "lat": lat,
        "lng": lng,
    };
}

class PesoEdad {
    PesoEdad({
        required this.edadMeses,
        required this.fecha,
        required this.pesoKg,
    });

    int edadMeses;
    String fecha;
    double pesoKg;

    factory PesoEdad.fromJson(String str) => PesoEdad.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PesoEdad.fromMap(Map<String, dynamic> json) => PesoEdad(
        edadMeses: json["edadMeses"],
        fecha: json["fecha"],
        pesoKg: json["pesoKg"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "edadMeses": edadMeses,
        "fecha": fecha,
        "pesoKg": pesoKg,
    };
}

class TallaEdad {
    TallaEdad({
        required this.edadMeses,
        required this.fecha,
        required this.tallaCm,
    });

    int edadMeses;
    String fecha;
    double tallaCm;

    factory TallaEdad.fromJson(String str) => TallaEdad.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TallaEdad.fromMap(Map<String, dynamic> json) => TallaEdad(
        edadMeses: json["edadMeses"],
        fecha: json["fecha"],
        tallaCm: json["tallaCm"],
    );

    Map<String, dynamic> toMap() => {
        "edadMeses": edadMeses,
        "fecha": fecha,
        "tallaCm": tallaCm,
    };
}

class Tutor {
    Tutor({
        required this.cui,
        required this.direccion,
        required this.nombre,
        required this.telefono,
    });

    String cui;
    String direccion;
    String nombre;
    String telefono;

    factory Tutor.fromJson(String str) => Tutor.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Tutor.fromMap(Map<String, dynamic> json) => Tutor(
        cui: json["cui"].toString(),
        direccion: json["direccion"],
        nombre: json["nombre"],
        telefono: json["telefono"].toString()
    );

    Map<String, dynamic> toMap() => {
        "cui": cui,
        "direccion": direccion,
        "nombre": nombre,
        "telefono": telefono,
    };

}
