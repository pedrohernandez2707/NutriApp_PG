import 'dart:convert';


class TablaTallaEdad{

  int meses;
  double tallaInicio;
  double tallaFin;
  String resultado;
  String genero;

  final List<TablaTallaEdad> tallas = [];

  TablaTallaEdad({
    required this.meses,
    required this.tallaInicio,
    required this.tallaFin,
    required this.resultado,
    required this.genero
  });


  factory TablaTallaEdad.fromJson(String str) => TablaTallaEdad.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TablaTallaEdad.fromMap(Map<String, dynamic> json) => TablaTallaEdad(
        meses: json["meses"].toInt(),
        tallaInicio: json["talla"].toDouble(),
        resultado: json["resultado"].toString(),
        genero: json["genero"].toDouble(),
        tallaFin:  json["talla"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "meses": meses,
        "talla": tallaFin,
        "resultado": resultado,
        "genero": genero,
    };

}