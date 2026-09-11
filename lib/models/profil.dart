class Profil {
  final String id;
  final String? pseudo;

  Profil({
    required this.id,
    this.pseudo,
  });

  factory Profil.fromJson(Map<String, dynamic> json) {
    return Profil(
      id: json['id'],
      pseudo: json['pseudo'],
    );
  }
}
