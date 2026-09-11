class StyleVin {
  final int id;
  final String libelle;
  final int couleurId;
  final int temperatureServiceId;

  StyleVin({
    required this.id,
    required this.libelle,
    required this.couleurId,
    required this.temperatureServiceId,
  });

  factory StyleVin.fromJson(Map<String, dynamic> json) {
    return StyleVin(
      id: json['id'],
      libelle: json['libelle'],
      couleurId: json['couleur_id'],
      temperatureServiceId: json['temperature_service_id'],
    );
  }
}
