// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bridge_generated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$InputType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(LNInvoice field0, BitcoinAddressData field1)
        bolt11WithOnchainFallback,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(String field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_Bolt11WithOnchainFallback value)
        bolt11WithOnchainFallback,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InputTypeCopyWith<$Res> {
  factory $InputTypeCopyWith(InputType value, $Res Function(InputType) then) =
      _$InputTypeCopyWithImpl<$Res>;
}

/// @nodoc
class _$InputTypeCopyWithImpl<$Res> implements $InputTypeCopyWith<$Res> {
  _$InputTypeCopyWithImpl(this._value, this._then);

  final InputType _value;
  // ignore: unused_field
  final $Res Function(InputType) _then;
}

/// @nodoc
abstract class _$$InputType_BitcoinAddressCopyWith<$Res> {
  factory _$$InputType_BitcoinAddressCopyWith(_$InputType_BitcoinAddress value,
          $Res Function(_$InputType_BitcoinAddress) then) =
      __$$InputType_BitcoinAddressCopyWithImpl<$Res>;
  $Res call({BitcoinAddressData field0});
}

/// @nodoc
class __$$InputType_BitcoinAddressCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res>
    implements _$$InputType_BitcoinAddressCopyWith<$Res> {
  __$$InputType_BitcoinAddressCopyWithImpl(_$InputType_BitcoinAddress _value,
      $Res Function(_$InputType_BitcoinAddress) _then)
      : super(_value, (v) => _then(v as _$InputType_BitcoinAddress));

  @override
  _$InputType_BitcoinAddress get _value =>
      super._value as _$InputType_BitcoinAddress;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$InputType_BitcoinAddress(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as BitcoinAddressData,
    ));
  }
}

/// @nodoc

class _$InputType_BitcoinAddress implements InputType_BitcoinAddress {
  const _$InputType_BitcoinAddress(this.field0);

  @override
  final BitcoinAddressData field0;

  @override
  String toString() {
    return 'InputType.bitcoinAddress(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_BitcoinAddress &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$InputType_BitcoinAddressCopyWith<_$InputType_BitcoinAddress>
      get copyWith =>
          __$$InputType_BitcoinAddressCopyWithImpl<_$InputType_BitcoinAddress>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(LNInvoice field0, BitcoinAddressData field1)
        bolt11WithOnchainFallback,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(String field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) {
    return bitcoinAddress(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
  }) {
    return bitcoinAddress?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_Bolt11WithOnchainFallback value)
        bolt11WithOnchainFallback,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
  }) {
    return bitcoinAddress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
  }) {
    return bitcoinAddress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (bitcoinAddress != null) {
      return bitcoinAddress(this);
    }
    return orElse();
  }
}

abstract class InputType_BitcoinAddress implements InputType {
  const factory InputType_BitcoinAddress(final BitcoinAddressData field0) =
      _$InputType_BitcoinAddress;

  BitcoinAddressData get field0;
  @JsonKey(ignore: true)
  _$$InputType_BitcoinAddressCopyWith<_$InputType_BitcoinAddress>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_Bolt11CopyWith<$Res> {
  factory _$$InputType_Bolt11CopyWith(
          _$InputType_Bolt11 value, $Res Function(_$InputType_Bolt11) then) =
      __$$InputType_Bolt11CopyWithImpl<$Res>;
  $Res call({LNInvoice field0});
}

/// @nodoc
class __$$InputType_Bolt11CopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res>
    implements _$$InputType_Bolt11CopyWith<$Res> {
  __$$InputType_Bolt11CopyWithImpl(
      _$InputType_Bolt11 _value, $Res Function(_$InputType_Bolt11) _then)
      : super(_value, (v) => _then(v as _$InputType_Bolt11));

  @override
  _$InputType_Bolt11 get _value => super._value as _$InputType_Bolt11;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$InputType_Bolt11(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LNInvoice,
    ));
  }
}

/// @nodoc

class _$InputType_Bolt11 implements InputType_Bolt11 {
  const _$InputType_Bolt11(this.field0);

  @override
  final LNInvoice field0;

  @override
  String toString() {
    return 'InputType.bolt11(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_Bolt11 &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$InputType_Bolt11CopyWith<_$InputType_Bolt11> get copyWith =>
      __$$InputType_Bolt11CopyWithImpl<_$InputType_Bolt11>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(LNInvoice field0, BitcoinAddressData field1)
        bolt11WithOnchainFallback,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(String field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) {
    return bolt11(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
  }) {
    return bolt11?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (bolt11 != null) {
      return bolt11(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_Bolt11WithOnchainFallback value)
        bolt11WithOnchainFallback,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
  }) {
    return bolt11(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
  }) {
    return bolt11?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (bolt11 != null) {
      return bolt11(this);
    }
    return orElse();
  }
}

abstract class InputType_Bolt11 implements InputType {
  const factory InputType_Bolt11(final LNInvoice field0) = _$InputType_Bolt11;

  LNInvoice get field0;
  @JsonKey(ignore: true)
  _$$InputType_Bolt11CopyWith<_$InputType_Bolt11> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_Bolt11WithOnchainFallbackCopyWith<$Res> {
  factory _$$InputType_Bolt11WithOnchainFallbackCopyWith(
          _$InputType_Bolt11WithOnchainFallback value,
          $Res Function(_$InputType_Bolt11WithOnchainFallback) then) =
      __$$InputType_Bolt11WithOnchainFallbackCopyWithImpl<$Res>;
  $Res call({LNInvoice field0, BitcoinAddressData field1});
}

/// @nodoc
class __$$InputType_Bolt11WithOnchainFallbackCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res>
    implements _$$InputType_Bolt11WithOnchainFallbackCopyWith<$Res> {
  __$$InputType_Bolt11WithOnchainFallbackCopyWithImpl(
      _$InputType_Bolt11WithOnchainFallback _value,
      $Res Function(_$InputType_Bolt11WithOnchainFallback) _then)
      : super(_value, (v) => _then(v as _$InputType_Bolt11WithOnchainFallback));

  @override
  _$InputType_Bolt11WithOnchainFallback get _value =>
      super._value as _$InputType_Bolt11WithOnchainFallback;

  @override
  $Res call({
    Object? field0 = freezed,
    Object? field1 = freezed,
  }) {
    return _then(_$InputType_Bolt11WithOnchainFallback(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as LNInvoice,
      field1 == freezed
          ? _value.field1
          : field1 // ignore: cast_nullable_to_non_nullable
              as BitcoinAddressData,
    ));
  }
}

/// @nodoc

class _$InputType_Bolt11WithOnchainFallback
    implements InputType_Bolt11WithOnchainFallback {
  const _$InputType_Bolt11WithOnchainFallback(this.field0, this.field1);

  @override
  final LNInvoice field0;
  @override
  final BitcoinAddressData field1;

  @override
  String toString() {
    return 'InputType.bolt11WithOnchainFallback(field0: $field0, field1: $field1)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_Bolt11WithOnchainFallback &&
            const DeepCollectionEquality().equals(other.field0, field0) &&
            const DeepCollectionEquality().equals(other.field1, field1));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(field0),
      const DeepCollectionEquality().hash(field1));

  @JsonKey(ignore: true)
  @override
  _$$InputType_Bolt11WithOnchainFallbackCopyWith<
          _$InputType_Bolt11WithOnchainFallback>
      get copyWith => __$$InputType_Bolt11WithOnchainFallbackCopyWithImpl<
          _$InputType_Bolt11WithOnchainFallback>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(LNInvoice field0, BitcoinAddressData field1)
        bolt11WithOnchainFallback,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(String field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) {
    return bolt11WithOnchainFallback(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
  }) {
    return bolt11WithOnchainFallback?.call(field0, field1);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (bolt11WithOnchainFallback != null) {
      return bolt11WithOnchainFallback(field0, field1);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_Bolt11WithOnchainFallback value)
        bolt11WithOnchainFallback,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
  }) {
    return bolt11WithOnchainFallback(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
  }) {
    return bolt11WithOnchainFallback?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (bolt11WithOnchainFallback != null) {
      return bolt11WithOnchainFallback(this);
    }
    return orElse();
  }
}

abstract class InputType_Bolt11WithOnchainFallback implements InputType {
  const factory InputType_Bolt11WithOnchainFallback(
          final LNInvoice field0, final BitcoinAddressData field1) =
      _$InputType_Bolt11WithOnchainFallback;

  LNInvoice get field0;
  BitcoinAddressData get field1;
  @JsonKey(ignore: true)
  _$$InputType_Bolt11WithOnchainFallbackCopyWith<
          _$InputType_Bolt11WithOnchainFallback>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_NodeIdCopyWith<$Res> {
  factory _$$InputType_NodeIdCopyWith(
          _$InputType_NodeId value, $Res Function(_$InputType_NodeId) then) =
      __$$InputType_NodeIdCopyWithImpl<$Res>;
  $Res call({String field0});
}

/// @nodoc
class __$$InputType_NodeIdCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res>
    implements _$$InputType_NodeIdCopyWith<$Res> {
  __$$InputType_NodeIdCopyWithImpl(
      _$InputType_NodeId _value, $Res Function(_$InputType_NodeId) _then)
      : super(_value, (v) => _then(v as _$InputType_NodeId));

  @override
  _$InputType_NodeId get _value => super._value as _$InputType_NodeId;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$InputType_NodeId(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_NodeId implements InputType_NodeId {
  const _$InputType_NodeId(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'InputType.nodeId(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_NodeId &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$InputType_NodeIdCopyWith<_$InputType_NodeId> get copyWith =>
      __$$InputType_NodeIdCopyWithImpl<_$InputType_NodeId>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(LNInvoice field0, BitcoinAddressData field1)
        bolt11WithOnchainFallback,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(String field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) {
    return nodeId(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
  }) {
    return nodeId?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (nodeId != null) {
      return nodeId(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_Bolt11WithOnchainFallback value)
        bolt11WithOnchainFallback,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
  }) {
    return nodeId(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
  }) {
    return nodeId?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (nodeId != null) {
      return nodeId(this);
    }
    return orElse();
  }
}

abstract class InputType_NodeId implements InputType {
  const factory InputType_NodeId(final String field0) = _$InputType_NodeId;

  String get field0;
  @JsonKey(ignore: true)
  _$$InputType_NodeIdCopyWith<_$InputType_NodeId> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_UrlCopyWith<$Res> {
  factory _$$InputType_UrlCopyWith(
          _$InputType_Url value, $Res Function(_$InputType_Url) then) =
      __$$InputType_UrlCopyWithImpl<$Res>;
  $Res call({String field0});
}

/// @nodoc
class __$$InputType_UrlCopyWithImpl<$Res> extends _$InputTypeCopyWithImpl<$Res>
    implements _$$InputType_UrlCopyWith<$Res> {
  __$$InputType_UrlCopyWithImpl(
      _$InputType_Url _value, $Res Function(_$InputType_Url) _then)
      : super(_value, (v) => _then(v as _$InputType_Url));

  @override
  _$InputType_Url get _value => super._value as _$InputType_Url;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$InputType_Url(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_Url implements InputType_Url {
  const _$InputType_Url(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'InputType.url(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_Url &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$InputType_UrlCopyWith<_$InputType_Url> get copyWith =>
      __$$InputType_UrlCopyWithImpl<_$InputType_Url>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(LNInvoice field0, BitcoinAddressData field1)
        bolt11WithOnchainFallback,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(String field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) {
    return url(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
  }) {
    return url?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_Bolt11WithOnchainFallback value)
        bolt11WithOnchainFallback,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
  }) {
    return url(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
  }) {
    return url?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (url != null) {
      return url(this);
    }
    return orElse();
  }
}

abstract class InputType_Url implements InputType {
  const factory InputType_Url(final String field0) = _$InputType_Url;

  String get field0;
  @JsonKey(ignore: true)
  _$$InputType_UrlCopyWith<_$InputType_Url> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlPayCopyWith<$Res> {
  factory _$$InputType_LnUrlPayCopyWith(_$InputType_LnUrlPay value,
          $Res Function(_$InputType_LnUrlPay) then) =
      __$$InputType_LnUrlPayCopyWithImpl<$Res>;
  $Res call({String field0});
}

/// @nodoc
class __$$InputType_LnUrlPayCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res>
    implements _$$InputType_LnUrlPayCopyWith<$Res> {
  __$$InputType_LnUrlPayCopyWithImpl(
      _$InputType_LnUrlPay _value, $Res Function(_$InputType_LnUrlPay) _then)
      : super(_value, (v) => _then(v as _$InputType_LnUrlPay));

  @override
  _$InputType_LnUrlPay get _value => super._value as _$InputType_LnUrlPay;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$InputType_LnUrlPay(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlPay implements InputType_LnUrlPay {
  const _$InputType_LnUrlPay(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'InputType.lnUrlPay(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlPay &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$InputType_LnUrlPayCopyWith<_$InputType_LnUrlPay> get copyWith =>
      __$$InputType_LnUrlPayCopyWithImpl<_$InputType_LnUrlPay>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(LNInvoice field0, BitcoinAddressData field1)
        bolt11WithOnchainFallback,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(String field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) {
    return lnUrlPay(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
  }) {
    return lnUrlPay?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_Bolt11WithOnchainFallback value)
        bolt11WithOnchainFallback,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
  }) {
    return lnUrlPay(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
  }) {
    return lnUrlPay?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (lnUrlPay != null) {
      return lnUrlPay(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlPay implements InputType {
  const factory InputType_LnUrlPay(final String field0) = _$InputType_LnUrlPay;

  String get field0;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlPayCopyWith<_$InputType_LnUrlPay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InputType_LnUrlWithdrawCopyWith<$Res> {
  factory _$$InputType_LnUrlWithdrawCopyWith(_$InputType_LnUrlWithdraw value,
          $Res Function(_$InputType_LnUrlWithdraw) then) =
      __$$InputType_LnUrlWithdrawCopyWithImpl<$Res>;
  $Res call({String field0});
}

/// @nodoc
class __$$InputType_LnUrlWithdrawCopyWithImpl<$Res>
    extends _$InputTypeCopyWithImpl<$Res>
    implements _$$InputType_LnUrlWithdrawCopyWith<$Res> {
  __$$InputType_LnUrlWithdrawCopyWithImpl(_$InputType_LnUrlWithdraw _value,
      $Res Function(_$InputType_LnUrlWithdraw) _then)
      : super(_value, (v) => _then(v as _$InputType_LnUrlWithdraw));

  @override
  _$InputType_LnUrlWithdraw get _value =>
      super._value as _$InputType_LnUrlWithdraw;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$InputType_LnUrlWithdraw(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InputType_LnUrlWithdraw implements InputType_LnUrlWithdraw {
  const _$InputType_LnUrlWithdraw(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'InputType.lnUrlWithdraw(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InputType_LnUrlWithdraw &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$InputType_LnUrlWithdrawCopyWith<_$InputType_LnUrlWithdraw> get copyWith =>
      __$$InputType_LnUrlWithdrawCopyWithImpl<_$InputType_LnUrlWithdraw>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(BitcoinAddressData field0) bitcoinAddress,
    required TResult Function(LNInvoice field0) bolt11,
    required TResult Function(LNInvoice field0, BitcoinAddressData field1)
        bolt11WithOnchainFallback,
    required TResult Function(String field0) nodeId,
    required TResult Function(String field0) url,
    required TResult Function(String field0) lnUrlPay,
    required TResult Function(String field0) lnUrlWithdraw,
  }) {
    return lnUrlWithdraw(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
  }) {
    return lnUrlWithdraw?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(BitcoinAddressData field0)? bitcoinAddress,
    TResult Function(LNInvoice field0)? bolt11,
    TResult Function(LNInvoice field0, BitcoinAddressData field1)?
        bolt11WithOnchainFallback,
    TResult Function(String field0)? nodeId,
    TResult Function(String field0)? url,
    TResult Function(String field0)? lnUrlPay,
    TResult Function(String field0)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(InputType_BitcoinAddress value) bitcoinAddress,
    required TResult Function(InputType_Bolt11 value) bolt11,
    required TResult Function(InputType_Bolt11WithOnchainFallback value)
        bolt11WithOnchainFallback,
    required TResult Function(InputType_NodeId value) nodeId,
    required TResult Function(InputType_Url value) url,
    required TResult Function(InputType_LnUrlPay value) lnUrlPay,
    required TResult Function(InputType_LnUrlWithdraw value) lnUrlWithdraw,
  }) {
    return lnUrlWithdraw(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
  }) {
    return lnUrlWithdraw?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(InputType_BitcoinAddress value)? bitcoinAddress,
    TResult Function(InputType_Bolt11 value)? bolt11,
    TResult Function(InputType_Bolt11WithOnchainFallback value)?
        bolt11WithOnchainFallback,
    TResult Function(InputType_NodeId value)? nodeId,
    TResult Function(InputType_Url value)? url,
    TResult Function(InputType_LnUrlPay value)? lnUrlPay,
    TResult Function(InputType_LnUrlWithdraw value)? lnUrlWithdraw,
    required TResult orElse(),
  }) {
    if (lnUrlWithdraw != null) {
      return lnUrlWithdraw(this);
    }
    return orElse();
  }
}

abstract class InputType_LnUrlWithdraw implements InputType {
  const factory InputType_LnUrlWithdraw(final String field0) =
      _$InputType_LnUrlWithdraw;

  String get field0;
  @JsonKey(ignore: true)
  _$$InputType_LnUrlWithdrawCopyWith<_$InputType_LnUrlWithdraw> get copyWith =>
      throw _privateConstructorUsedError;
}
