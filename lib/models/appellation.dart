class Appellation {
  final int id;
  final String nom;
  final int regionId;
  final int? sousRegionId;

  Appellation({
    required this.id,
    required this.nom,
    required this.regionId,
    this.sousRegionId,
  });

  factory Appellation.fromJson(Map<String, dynamic> json) {
    return Appellation(
      id: json['id'],
      nom: json['nom'],
      regionId: json['region_id'],
      sousRegionId: json['sous_region_id'],
    );
  }
}
