import 'dart:convert';

class Usuario {
    Usuario({
        required this.email,
        required this.firebaseToken,
        required this.nombre,
        required this.password,
        this.id,
        required this.permisos
    });

    String email;
    String firebaseToken;
    String nombre;
    String password;
    String? id;
    Permisos permisos;

    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        email: json["Email"],
        firebaseToken: json["Firebase_token"],
        nombre: json["Nombre"],
        password: json["Password"],
        permisos: Permisos.fromMap(json["Permisos"])
    );

    Map<String, dynamic> toMap() => {
        "Email": email,
        "Firebase_token": firebaseToken,
        "Nombre": nombre,
        "Password": password,
        "Permisos": permisos.toMap()
    };

    Usuario copy()=> Usuario(
      email: email, 
      firebaseToken: firebaseToken, 
      nombre: nombre, 
      password: password,
      permisos: permisos,
      id: id
    );
}


class Permisos {
    Permisos({
        required this.geolocalizacion,
        required this.registro,
        required this.usuarios,
        required this.visualizacion,
    });

    bool geolocalizacion;
    bool registro;
    bool usuarios;
    bool visualizacion;

    factory Permisos.fromJson(String str) => Permisos.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Permisos.fromMap(Map<String, dynamic> json) => Permisos(
        geolocalizacion: json["Geolocalizacion"],
        registro: json["Registro"],
        usuarios: json["Usuarios"],
        visualizacion: json["Visualizacion"],
    );

    Map<String, dynamic> toMap() => {
        "Geolocalizacion": geolocalizacion,
        "Registro": registro,
        "Usuarios": usuarios,
        "Visualizacion": visualizacion,
    };
}
