// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bobbin_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BobbinData {
  String get filamentType => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get weightGrams => throw _privateConstructorUsedError;
  DateTime? get manufactureDate => throw _privateConstructorUsedError;
  String? get batchNumber => throw _privateConstructorUsedError;
  int? get colorRgb =>
      throw _privateConstructorUsedError; // RGB color as integer (0xRRGGBB)
  int? get extruderTempMin =>
      throw _privateConstructorUsedError; // Température extrudeur min (°C)
  int? get extruderTempMax =>
      throw _privateConstructorUsedError; // Température extrudeur max (°C)
  int? get bedTempMin =>
      throw _privateConstructorUsedError; // Température plateau min (°C)
  int? get bedTempMax =>
      throw _privateConstructorUsedError; // Température plateau max (°C)
  double? get diameter =>
      throw _privateConstructorUsedError; // Diamètre filament (mm)
  int? get spoolLength =>
      throw _privateConstructorUsedError; // Longueur bobine (mètres)
  double? get price => throw _privateConstructorUsedError; // Prix d'achat (CHF)
  double? get remainingWeight =>
      throw _privateConstructorUsedError; // Poids restant (grammes)
  String? get brand => throw _privateConstructorUsedError;

  /// Create a copy of BobbinData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BobbinDataCopyWith<BobbinData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BobbinDataCopyWith<$Res> {
  factory $BobbinDataCopyWith(
    BobbinData value,
    $Res Function(BobbinData) then,
  ) = _$BobbinDataCopyWithImpl<$Res, BobbinData>;
  @useResult
  $Res call({
    String filamentType,
    String color,
    double weightGrams,
    DateTime? manufactureDate,
    String? batchNumber,
    int? colorRgb,
    int? extruderTempMin,
    int? extruderTempMax,
    int? bedTempMin,
    int? bedTempMax,
    double? diameter,
    int? spoolLength,
    double? price,
    double? remainingWeight,
    String? brand,
  });
}

/// @nodoc
class _$BobbinDataCopyWithImpl<$Res, $Val extends BobbinData>
    implements $BobbinDataCopyWith<$Res> {
  _$BobbinDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BobbinData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filamentType = null,
    Object? color = null,
    Object? weightGrams = null,
    Object? manufactureDate = freezed,
    Object? batchNumber = freezed,
    Object? colorRgb = freezed,
    Object? extruderTempMin = freezed,
    Object? extruderTempMax = freezed,
    Object? bedTempMin = freezed,
    Object? bedTempMax = freezed,
    Object? diameter = freezed,
    Object? spoolLength = freezed,
    Object? price = freezed,
    Object? remainingWeight = freezed,
    Object? brand = freezed,
  }) {
    return _then(
      _value.copyWith(
            filamentType: null == filamentType
                ? _value.filamentType
                : filamentType // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            weightGrams: null == weightGrams
                ? _value.weightGrams
                : weightGrams // ignore: cast_nullable_to_non_nullable
                      as double,
            manufactureDate: freezed == manufactureDate
                ? _value.manufactureDate
                : manufactureDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            batchNumber: freezed == batchNumber
                ? _value.batchNumber
                : batchNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            colorRgb: freezed == colorRgb
                ? _value.colorRgb
                : colorRgb // ignore: cast_nullable_to_non_nullable
                      as int?,
            extruderTempMin: freezed == extruderTempMin
                ? _value.extruderTempMin
                : extruderTempMin // ignore: cast_nullable_to_non_nullable
                      as int?,
            extruderTempMax: freezed == extruderTempMax
                ? _value.extruderTempMax
                : extruderTempMax // ignore: cast_nullable_to_non_nullable
                      as int?,
            bedTempMin: freezed == bedTempMin
                ? _value.bedTempMin
                : bedTempMin // ignore: cast_nullable_to_non_nullable
                      as int?,
            bedTempMax: freezed == bedTempMax
                ? _value.bedTempMax
                : bedTempMax // ignore: cast_nullable_to_non_nullable
                      as int?,
            diameter: freezed == diameter
                ? _value.diameter
                : diameter // ignore: cast_nullable_to_non_nullable
                      as double?,
            spoolLength: freezed == spoolLength
                ? _value.spoolLength
                : spoolLength // ignore: cast_nullable_to_non_nullable
                      as int?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            remainingWeight: freezed == remainingWeight
                ? _value.remainingWeight
                : remainingWeight // ignore: cast_nullable_to_non_nullable
                      as double?,
            brand: freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BobbinDataImplCopyWith<$Res>
    implements $BobbinDataCopyWith<$Res> {
  factory _$$BobbinDataImplCopyWith(
    _$BobbinDataImpl value,
    $Res Function(_$BobbinDataImpl) then,
  ) = __$$BobbinDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String filamentType,
    String color,
    double weightGrams,
    DateTime? manufactureDate,
    String? batchNumber,
    int? colorRgb,
    int? extruderTempMin,
    int? extruderTempMax,
    int? bedTempMin,
    int? bedTempMax,
    double? diameter,
    int? spoolLength,
    double? price,
    double? remainingWeight,
    String? brand,
  });
}

/// @nodoc
class __$$BobbinDataImplCopyWithImpl<$Res>
    extends _$BobbinDataCopyWithImpl<$Res, _$BobbinDataImpl>
    implements _$$BobbinDataImplCopyWith<$Res> {
  __$$BobbinDataImplCopyWithImpl(
    _$BobbinDataImpl _value,
    $Res Function(_$BobbinDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BobbinData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filamentType = null,
    Object? color = null,
    Object? weightGrams = null,
    Object? manufactureDate = freezed,
    Object? batchNumber = freezed,
    Object? colorRgb = freezed,
    Object? extruderTempMin = freezed,
    Object? extruderTempMax = freezed,
    Object? bedTempMin = freezed,
    Object? bedTempMax = freezed,
    Object? diameter = freezed,
    Object? spoolLength = freezed,
    Object? price = freezed,
    Object? remainingWeight = freezed,
    Object? brand = freezed,
  }) {
    return _then(
      _$BobbinDataImpl(
        filamentType: null == filamentType
            ? _value.filamentType
            : filamentType // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        weightGrams: null == weightGrams
            ? _value.weightGrams
            : weightGrams // ignore: cast_nullable_to_non_nullable
                  as double,
        manufactureDate: freezed == manufactureDate
            ? _value.manufactureDate
            : manufactureDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        batchNumber: freezed == batchNumber
            ? _value.batchNumber
            : batchNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        colorRgb: freezed == colorRgb
            ? _value.colorRgb
            : colorRgb // ignore: cast_nullable_to_non_nullable
                  as int?,
        extruderTempMin: freezed == extruderTempMin
            ? _value.extruderTempMin
            : extruderTempMin // ignore: cast_nullable_to_non_nullable
                  as int?,
        extruderTempMax: freezed == extruderTempMax
            ? _value.extruderTempMax
            : extruderTempMax // ignore: cast_nullable_to_non_nullable
                  as int?,
        bedTempMin: freezed == bedTempMin
            ? _value.bedTempMin
            : bedTempMin // ignore: cast_nullable_to_non_nullable
                  as int?,
        bedTempMax: freezed == bedTempMax
            ? _value.bedTempMax
            : bedTempMax // ignore: cast_nullable_to_non_nullable
                  as int?,
        diameter: freezed == diameter
            ? _value.diameter
            : diameter // ignore: cast_nullable_to_non_nullable
                  as double?,
        spoolLength: freezed == spoolLength
            ? _value.spoolLength
            : spoolLength // ignore: cast_nullable_to_non_nullable
                  as int?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        remainingWeight: freezed == remainingWeight
            ? _value.remainingWeight
            : remainingWeight // ignore: cast_nullable_to_non_nullable
                  as double?,
        brand: freezed == brand
            ? _value.brand
            : brand // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BobbinDataImpl implements _BobbinData {
  const _$BobbinDataImpl({
    required this.filamentType,
    required this.color,
    required this.weightGrams,
    this.manufactureDate,
    this.batchNumber,
    this.colorRgb,
    this.extruderTempMin,
    this.extruderTempMax,
    this.bedTempMin,
    this.bedTempMax,
    this.diameter,
    this.spoolLength,
    this.price,
    this.remainingWeight,
    this.brand,
  });

  @override
  final String filamentType;
  @override
  final String color;
  @override
  final double weightGrams;
  @override
  final DateTime? manufactureDate;
  @override
  final String? batchNumber;
  @override
  final int? colorRgb;
  // RGB color as integer (0xRRGGBB)
  @override
  final int? extruderTempMin;
  // Température extrudeur min (°C)
  @override
  final int? extruderTempMax;
  // Température extrudeur max (°C)
  @override
  final int? bedTempMin;
  // Température plateau min (°C)
  @override
  final int? bedTempMax;
  // Température plateau max (°C)
  @override
  final double? diameter;
  // Diamètre filament (mm)
  @override
  final int? spoolLength;
  // Longueur bobine (mètres)
  @override
  final double? price;
  // Prix d'achat (CHF)
  @override
  final double? remainingWeight;
  // Poids restant (grammes)
  @override
  final String? brand;

  @override
  String toString() {
    return 'BobbinData(filamentType: $filamentType, color: $color, weightGrams: $weightGrams, manufactureDate: $manufactureDate, batchNumber: $batchNumber, colorRgb: $colorRgb, extruderTempMin: $extruderTempMin, extruderTempMax: $extruderTempMax, bedTempMin: $bedTempMin, bedTempMax: $bedTempMax, diameter: $diameter, spoolLength: $spoolLength, price: $price, remainingWeight: $remainingWeight, brand: $brand)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BobbinDataImpl &&
            (identical(other.filamentType, filamentType) ||
                other.filamentType == filamentType) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.weightGrams, weightGrams) ||
                other.weightGrams == weightGrams) &&
            (identical(other.manufactureDate, manufactureDate) ||
                other.manufactureDate == manufactureDate) &&
            (identical(other.batchNumber, batchNumber) ||
                other.batchNumber == batchNumber) &&
            (identical(other.colorRgb, colorRgb) ||
                other.colorRgb == colorRgb) &&
            (identical(other.extruderTempMin, extruderTempMin) ||
                other.extruderTempMin == extruderTempMin) &&
            (identical(other.extruderTempMax, extruderTempMax) ||
                other.extruderTempMax == extruderTempMax) &&
            (identical(other.bedTempMin, bedTempMin) ||
                other.bedTempMin == bedTempMin) &&
            (identical(other.bedTempMax, bedTempMax) ||
                other.bedTempMax == bedTempMax) &&
            (identical(other.diameter, diameter) ||
                other.diameter == diameter) &&
            (identical(other.spoolLength, spoolLength) ||
                other.spoolLength == spoolLength) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.remainingWeight, remainingWeight) ||
                other.remainingWeight == remainingWeight) &&
            (identical(other.brand, brand) || other.brand == brand));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    filamentType,
    color,
    weightGrams,
    manufactureDate,
    batchNumber,
    colorRgb,
    extruderTempMin,
    extruderTempMax,
    bedTempMin,
    bedTempMax,
    diameter,
    spoolLength,
    price,
    remainingWeight,
    brand,
  );

  /// Create a copy of BobbinData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BobbinDataImplCopyWith<_$BobbinDataImpl> get copyWith =>
      __$$BobbinDataImplCopyWithImpl<_$BobbinDataImpl>(this, _$identity);
}

abstract class _BobbinData implements BobbinData {
  const factory _BobbinData({
    required final String filamentType,
    required final String color,
    required final double weightGrams,
    final DateTime? manufactureDate,
    final String? batchNumber,
    final int? colorRgb,
    final int? extruderTempMin,
    final int? extruderTempMax,
    final int? bedTempMin,
    final int? bedTempMax,
    final double? diameter,
    final int? spoolLength,
    final double? price,
    final double? remainingWeight,
    final String? brand,
  }) = _$BobbinDataImpl;

  @override
  String get filamentType;
  @override
  String get color;
  @override
  double get weightGrams;
  @override
  DateTime? get manufactureDate;
  @override
  String? get batchNumber;
  @override
  int? get colorRgb; // RGB color as integer (0xRRGGBB)
  @override
  int? get extruderTempMin; // Température extrudeur min (°C)
  @override
  int? get extruderTempMax; // Température extrudeur max (°C)
  @override
  int? get bedTempMin; // Température plateau min (°C)
  @override
  int? get bedTempMax; // Température plateau max (°C)
  @override
  double? get diameter; // Diamètre filament (mm)
  @override
  int? get spoolLength; // Longueur bobine (mètres)
  @override
  double? get price; // Prix d'achat (CHF)
  @override
  double? get remainingWeight; // Poids restant (grammes)
  @override
  String? get brand;

  /// Create a copy of BobbinData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BobbinDataImplCopyWith<_$BobbinDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
