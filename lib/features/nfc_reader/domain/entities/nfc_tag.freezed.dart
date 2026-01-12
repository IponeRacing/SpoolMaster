// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nfc_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NfcTag {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;

  /// Create a copy of NfcTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NfcTagCopyWith<NfcTag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NfcTagCopyWith<$Res> {
  factory $NfcTagCopyWith(NfcTag value, $Res Function(NfcTag) then) =
      _$NfcTagCopyWithImpl<$Res, NfcTag>;
  @useResult
  $Res call({
    String id,
    String type,
    String? manufacturer,
    Map<String, dynamic>? data,
  });
}

/// @nodoc
class _$NfcTagCopyWithImpl<$Res, $Val extends NfcTag>
    implements $NfcTagCopyWith<$Res> {
  _$NfcTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NfcTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? manufacturer = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            manufacturer: freezed == manufacturer
                ? _value.manufacturer
                : manufacturer // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NfcTagImplCopyWith<$Res> implements $NfcTagCopyWith<$Res> {
  factory _$$NfcTagImplCopyWith(
    _$NfcTagImpl value,
    $Res Function(_$NfcTagImpl) then,
  ) = __$$NfcTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    String? manufacturer,
    Map<String, dynamic>? data,
  });
}

/// @nodoc
class __$$NfcTagImplCopyWithImpl<$Res>
    extends _$NfcTagCopyWithImpl<$Res, _$NfcTagImpl>
    implements _$$NfcTagImplCopyWith<$Res> {
  __$$NfcTagImplCopyWithImpl(
    _$NfcTagImpl _value,
    $Res Function(_$NfcTagImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NfcTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? manufacturer = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$NfcTagImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        manufacturer: freezed == manufacturer
            ? _value.manufacturer
            : manufacturer // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc

class _$NfcTagImpl implements _NfcTag {
  const _$NfcTagImpl({
    required this.id,
    required this.type,
    this.manufacturer,
    final Map<String, dynamic>? data,
  }) : _data = data;

  @override
  final String id;
  @override
  final String type;
  @override
  final String? manufacturer;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NfcTag(id: $id, type: $type, manufacturer: $manufacturer, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NfcTagImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    manufacturer,
    const DeepCollectionEquality().hash(_data),
  );

  /// Create a copy of NfcTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NfcTagImplCopyWith<_$NfcTagImpl> get copyWith =>
      __$$NfcTagImplCopyWithImpl<_$NfcTagImpl>(this, _$identity);
}

abstract class _NfcTag implements NfcTag {
  const factory _NfcTag({
    required final String id,
    required final String type,
    final String? manufacturer,
    final Map<String, dynamic>? data,
  }) = _$NfcTagImpl;

  @override
  String get id;
  @override
  String get type;
  @override
  String? get manufacturer;
  @override
  Map<String, dynamic>? get data;

  /// Create a copy of NfcTag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NfcTagImplCopyWith<_$NfcTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
