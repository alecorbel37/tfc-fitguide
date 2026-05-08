class UserModel {
  final String uid;
  final String nombre;
  final String apellidos;
  final String email;
  final String objetivo;
  final double altura;
  final double peso;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.objetivo,
    required this.altura,
    required this.peso,
    required this.createdAt,
  });

  // Convertimos a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'objetivo': objetivo,
      'altura': altura,
      'peso': peso,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Creamos UserModel desde un Map de Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      nombre: map['nombre'] as String,
      apellidos: map['apellidos'] as String,
      email: map['email'] as String,
      objetivo: map['objetivo'] as String,
      altura: (map['altura'] as num).toDouble(),
      peso: (map['peso'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
