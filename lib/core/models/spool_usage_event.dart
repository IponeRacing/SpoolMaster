// Événement de consommation : une baisse du poids restant d'une bobine.
//
// Le poids restant d'une bobine est écrasé à chaque mise à jour ; sans
// historique, impossible de dire « 1,2 kg consommés ce mois ». Chaque baisse
// est donc journalisée ici, avec une copie des infos de la bobine (marque,
// matériau, couleur, prix au gramme) pour que l'historique reste lisible même
// après suppression de la bobine.
class SpoolUsageEvent {
  SpoolUsageEvent({
    required this.id,
    required this.spoolId,
    required this.date,
    required this.grams,
    required this.brand,
    required this.material,
    required this.colorName,
    required this.colorRgb,
    required this.cost,
    this.source = sourceUpdate,
  });

  factory SpoolUsageEvent.fromJson(Map<String, dynamic> json) =>
      SpoolUsageEvent(
        id: json['id'] as String,
        spoolId: json['spoolId'] as String,
        date: DateTime.parse(json['date'] as String),
        grams: (json['grams'] as num).toDouble(),
        brand: json['brand'] as String? ?? '',
        material: json['material'] as String? ?? '',
        colorName: json['colorName'] as String? ?? '',
        colorRgb: json['colorRgb'] as int? ?? 0,
        cost: (json['cost'] as num?)?.toDouble() ?? 0,
        source: json['source'] as String? ?? sourceUpdate,
      );

  /// Baisse saisie via l'édition / la mise à jour du stock.
  static const String sourceUpdate = 'update';

  /// Baisse saisie via le calculateur de coût d'impression.
  static const String sourcePrint = 'print';

  /// Correction d'une saisie erronée (poids remonté peu après une baisse) :
  /// grammes et coût NÉGATIFS, qui annulent tout ou partie de la
  /// consommation récente. Le journal reste additif (rien n'est supprimé),
  /// donc synchronisable entre appareils sans conflit.
  static const String sourceCorrection = 'correction';

  final String id;
  final String spoolId;
  final DateTime date;

  /// Grammes consommés (> 0), ou négatifs pour une correction.
  final double grams;
  final String brand;
  final String material;
  final String colorName;
  final int colorRgb;

  /// Coût de la matière consommée (prix bobine / poids initial × grammes),
  /// dans la devise de l'utilisateur au moment de l'événement.
  final double cost;
  final String source;

  Map<String, dynamic> toJson() => {
    'id': id,
    'spoolId': spoolId,
    'date': date.toIso8601String(),
    'grams': grams,
    'brand': brand,
    'material': material,
    'colorName': colorName,
    'colorRgb': colorRgb,
    'cost': cost,
    'source': source,
  };
}
