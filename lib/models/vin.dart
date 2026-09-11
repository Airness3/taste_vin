class Vin {
  final int id;
  final String nom;
  final int? millesime;
  final int appellationId;
  final int domaineId;
  final int styleVinId;
  final int? niveauPrestigeId;

  Vin({
    required this.id,
    required this.nom,
    this.millesime,
    required this.appellationId,
    required this.domaineId,
    required this.styleVinId,
    this.niveauPrestigeId,
  });

  factory Vin.fromJson(Map<String, dynamic> json) {
    return Vin(
      id: json['id'],
      nom: json['nom'],
      millesime: json['millesime'],
      appellationId: json['appellation_id'],
      domaineId: json['domaine_id'],
      styleVinId: json['style_vin_id'],
      niveauPrestigeId: json['niveau_prestige_id'],
    );
  }
}
