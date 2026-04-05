// Model for inventory items
class SpoolInventoryItem {
  final String id;
  final String brand;
  final String material;
  final String colorName;
  final int colorRgb;
  final double price;
  final double weight;
  final double remainingWeight;
  final DateTime addedDate;
  final int? extruderTempMin;
  final int? extruderTempMax;
  final int? bedTempMin;
  final int? bedTempMax;
  final double? diameter;
  final int? spoolLength;
  final DateTime? manufactureDate;
  final String? batchNumber;

  SpoolInventoryItem({
    required this.id,
    required this.brand,
    required this.material,
    required this.colorName,
    required this.colorRgb,
    required this.price,
    required this.weight,
    required this.remainingWeight,
    required this.addedDate,
    this.extruderTempMin,
    this.extruderTempMax,
    this.bedTempMin,
    this.bedTempMax,
    this.diameter,
    this.spoolLength,
    this.manufactureDate,
    this.batchNumber,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'material': material,
    'colorName': colorName,
    'colorRgb': colorRgb,
    'price': price,
    'weight': weight,
    'remainingWeight': remainingWeight,
    'addedDate': addedDate.toIso8601String(),
    'extruderTempMin': extruderTempMin,
    'extruderTempMax': extruderTempMax,
    'bedTempMin': bedTempMin,
    'bedTempMax': bedTempMax,
    'diameter': diameter,
    'spoolLength': spoolLength,
    'manufactureDate': manufactureDate?.toIso8601String(),
    'batchNumber': batchNumber,
  };

  factory SpoolInventoryItem.fromJson(Map<String, dynamic> json) =>
      SpoolInventoryItem(
        id: json['id'] as String,
        brand: json['brand'] as String,
        material: json['material'] as String,
        colorName: json['colorName'] as String,
        colorRgb: json['colorRgb'] as int,
        price: (json['price'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
        remainingWeight: (json['remainingWeight'] as num).toDouble(),
        addedDate: DateTime.parse(json['addedDate'] as String),
        extruderTempMin: json['extruderTempMin'] as int?,
        extruderTempMax: json['extruderTempMax'] as int?,
        bedTempMin: json['bedTempMin'] as int?,
        bedTempMax: json['bedTempMax'] as int?,
        diameter: json['diameter'] != null
            ? (json['diameter'] as num).toDouble()
            : null,
        spoolLength: json['spoolLength'] as int?,
        manufactureDate: json['manufactureDate'] != null
            ? DateTime.parse(json['manufactureDate'] as String)
            : null,
        batchNumber: json['batchNumber'] as String?,
      );

  SpoolInventoryItem copyWith({
    String? id,
    String? brand,
    String? material,
    String? colorName,
    int? colorRgb,
    double? price,
    double? weight,
    double? remainingWeight,
    DateTime? addedDate,
    int? extruderTempMin,
    int? extruderTempMax,
    int? bedTempMin,
    int? bedTempMax,
    double? diameter,
    int? spoolLength,
    DateTime? manufactureDate,
    String? batchNumber,
  }) {
    return SpoolInventoryItem(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      colorName: colorName ?? this.colorName,
      colorRgb: colorRgb ?? this.colorRgb,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      remainingWeight: remainingWeight ?? this.remainingWeight,
      addedDate: addedDate ?? this.addedDate,
      extruderTempMin: extruderTempMin ?? this.extruderTempMin,
      extruderTempMax: extruderTempMax ?? this.extruderTempMax,
      bedTempMin: bedTempMin ?? this.bedTempMin,
      bedTempMax: bedTempMax ?? this.bedTempMax,
      diameter: diameter ?? this.diameter,
      spoolLength: spoolLength ?? this.spoolLength,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      batchNumber: batchNumber ?? this.batchNumber,
    );
  }
}
