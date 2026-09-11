class Domaine {
  final int id;
  final String nom;

  Domaine({
    required this.id,
    required this.nom,
  });

  factory Domaine.fromJson(Map<String, dynamic> json) {
    return Domaine(
      id: json['id'],
      nom: json['nom'],
    );
  }
}
