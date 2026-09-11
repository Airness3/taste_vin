class ScanHistory {
  final int id;
  final int profilId;
  final int vinId;
  final String dateScan;

  ScanHistory({
    required this.id,
    required this.profilId,
    required this.vinId,
    required this.dateScan,
  });

  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    return ScanHistory(
      id: json['id'],
      profilId: json['profil_id'],
      vinId: json['vin_id'],
      dateScan: json['date_scan'],
    );
  }
}
