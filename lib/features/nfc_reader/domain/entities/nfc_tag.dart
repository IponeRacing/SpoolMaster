class NfcTag {
  const NfcTag({
    required this.id,
    required this.type,
    this.manufacturer,
    this.data,
  });

  final String id;
  final String type;
  final String? manufacturer;
  final Map<String, dynamic>? data;
}
