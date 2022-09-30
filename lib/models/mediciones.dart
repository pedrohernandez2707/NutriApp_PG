
import 'dart:convert';

class Medicion {
    Medicion({
      required this.cuiNinio,
      required this.edadMeses,
      required this.fechaMedicion,
      required this.notasPeso,
      required this.notasTalla,
      required this.pesoKg,
      required this.tallaCm,
      this.id
    });

    String cuiNinio;
    int edadMeses;
    String fechaMedicion;
    String notasPeso;
    String notasTalla;
    double pesoKg;
    double tallaCm;
    String? id;

    Medicion copy()=> Medicion(
      cuiNinio: cuiNinio,
      edadMeses: edadMeses,
      fechaMedicion: fechaMedicion,
      notasPeso: notasPeso,
      notasTalla: notasTalla,
      pesoKg: pesoKg,
      tallaCm: tallaCm,
      id: id
    );


    factory Medicion.fromJson(String str) => Medicion.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Medicion.fromMap(Map<String, dynamic> json) => Medicion(
      cuiNinio: json["cuiNinio"],
      edadMeses: json["edadMeses"],
      fechaMedicion: json["fechaMedicion"],
      notasPeso: json["notasPeso"],
      notasTalla: json["notasTalla"],
      pesoKg: json["pesoKg"].toDouble(),
      tallaCm: json["tallaCm"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
      "cuiNinio": cuiNinio,
      "edadMeses": edadMeses,
      "fechaMedicion": fechaMedicion,
      "notasPeso": notasPeso,
      "notasTalla": notasTalla,
      "pesoKg": pesoKg,
      "tallaCm": tallaCm,
    };
}
