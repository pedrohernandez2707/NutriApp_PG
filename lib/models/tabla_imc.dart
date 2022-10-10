import 'dart:convert';


class TablaImc{

  double imcInicio;
  double imcFin;
  String resultado;

  final List<TablaImc> tallas = [];

  TablaImc({
    required this.imcInicio,
    required this.imcFin,
    required this.resultado,
  });


  factory TablaImc.fromJson(String str) => TablaImc.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TablaImc.fromMap(Map<String, dynamic> json) => TablaImc(
        imcFin: json["talla"].toDouble(),
        resultado: json["resultado"].toString(),
        imcInicio: json["meses"].toInt(),
    );

    Map<String, dynamic> toMap() => {
        "imc": imcInicio,
        "resultado": resultado,
    };

}