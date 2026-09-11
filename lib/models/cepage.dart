class Cepage {
  final int id;
  final String nom;

  Cepage({
    required this.id,
    required this.nom,
  });

  factory Cepage.fromJson(Map<String, dynamic> json) {
    return Cepage(
      id: json['id'],
      nom: json['nom'],
    );
  }
}
