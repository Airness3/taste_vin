class Favori {
  final int id;
  final int profilId;
  final int vinId;
  final String dateAjout;

  Favori({
    required this.id,
    required this.profilId,
    required this.vinId,
    required this.dateAjout,
  });

  factory Favori.fromJson(Map<String, dynamic> json) {
    return Favori(
      id: json['id'],
      profilId: json['profil_id'],
      vinId: json['vin_id'],
      dateAjout: json['date_ajout'],
    );
  }
}
