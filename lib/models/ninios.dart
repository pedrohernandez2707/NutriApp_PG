
import 'dart:convert';

class Ninio {
    Ninio({
      required this.apellidos,
      required this.fechaNacimiento,
      required this.genero,
      this.geolocalizacion,
      required this.nombres,
      required this.tutor,
      this.id,
      required this.cui
    });

    String apellidos;
    String cui;
    String fechaNacimiento;
    String genero;
    Geolocalizacion? geolocalizacion;
    String nombres;
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
        tutor: Tutor.fromMap(json["tutor"]),
        cui: json["cui"]
    );

    Map<String, dynamic> toMap() => {
        "apellidos": apellidos,
        "fechaNacimiento": fechaNacimiento,
        "genero": genero,
        "geolocalizacion": geolocalizacion?.toMap(),
        "nombres": nombres,
        "tutor": tutor.toMap(),
        "cui": cui
    };

    Ninio copy()=> Ninio(
      apellidos: apellidos,
      nombres: nombres,
      fechaNacimiento: fechaNacimiento,
      genero: genero,
      id: id,
      tutor: tutor,
      cui: cui
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
