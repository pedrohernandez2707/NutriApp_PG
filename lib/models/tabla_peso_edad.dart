import 'dart:convert';


class TablaPesoEdad{

  int meses;
  double pesoInicio;
  double pesoFin;
  String resultado;
  String genero;

  final List<TablaPesoEdad> tallas = [];

  TablaPesoEdad({
    required this.meses,
    required this.pesoInicio,
    required this.pesoFin,
    required this.resultado,
    required this.genero
  });


  factory TablaPesoEdad.fromJson(String str) => TablaPesoEdad.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TablaPesoEdad.fromMap(Map<String, dynamic> json) => TablaPesoEdad(
        meses: json["meses"].toInt(),
        pesoInicio: json["talla"].toDouble(),
        resultado: json["resultado"].toString(),
        genero: json["genero"].toDouble(),
        pesoFin:  json["talla"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "meses": meses,
        "talla": pesoFin,
        "resultado": resultado,
        "genero": genero,
    };

}