class CaveEntry {
  final int id;
  final int profilId;
  final int vinId;
  final int quantite;
  final String? emplacement;

  CaveEntry({
    required this.id,
    required this.profilId,
    required this.vinId,
    required this.quantite,
    this.emplacement,
  });

  factory CaveEntry.fromJson(Map<String, dynamic> json) {
    return CaveEntry(
      id: json['id'],
      profilId: json['profil_id'],
      vinId: json['vin_id'],
      quantite: json['quantite'],
      emplacement: json['emplacement'],
    );
  }
}
