// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_user_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InventoryState implements DiagnosticableTreeMixin {

 Inventory get inventory; List<InventoryItem>? get searchedItems;
/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryStateCopyWith<InventoryState> get copyWith => _$InventoryStateCopyWithImpl<InventoryState>(this as InventoryState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InventoryState'))
    ..add(DiagnosticsProperty('inventory', inventory))..add(DiagnosticsProperty('searchedItems', searchedItems));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryState&&(identical(other.inventory, inventory) || other.inventory == inventory)&&const DeepCollectionEquality().equals(other.searchedItems, searchedItems));
}


@override
int get hashCode => Object.hash(runtimeType,inventory,const DeepCollectionEquality().hash(searchedItems));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InventoryState(inventory: $inventory, searchedItems: $searchedItems)';
}


}

/// @nodoc
abstract mixin class $InventoryStateCopyWith<$Res>  {
  factory $InventoryStateCopyWith(InventoryState value, $Res Function(InventoryState) _then) = _$InventoryStateCopyWithImpl;
@useResult
$Res call({
 Inventory inventory, List<InventoryItem>? searchedItems
});




}
/// @nodoc
class _$InventoryStateCopyWithImpl<$Res>
    implements $InventoryStateCopyWith<$Res> {
  _$InventoryStateCopyWithImpl(this._self, this._then);

  final InventoryState _self;
  final $Res Function(InventoryState) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inventory = null,Object? searchedItems = freezed,}) {
  return _then(_self.copyWith(
inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as Inventory,searchedItems: freezed == searchedItems ? _self.searchedItems : searchedItems // ignore: cast_nullable_to_non_nullable
as List<InventoryItem>?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryState].
extension InventoryStatePatterns on InventoryState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryState value)  $default,){
final _that = this;
switch (_that) {
case _InventoryState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryState value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Inventory inventory,  List<InventoryItem>? searchedItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryState() when $default != null:
return $default(_that.inventory,_that.searchedItems);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Inventory inventory,  List<InventoryItem>? searchedItems)  $default,) {final _that = this;
switch (_that) {
case _InventoryState():
return $default(_that.inventory,_that.searchedItems);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Inventory inventory,  List<InventoryItem>? searchedItems)?  $default,) {final _that = this;
switch (_that) {
case _InventoryState() when $default != null:
return $default(_that.inventory,_that.searchedItems);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryState with DiagnosticableTreeMixin implements InventoryState {
  const _InventoryState({required this.inventory, final  List<InventoryItem>? searchedItems}): _searchedItems = searchedItems;
  

@override final  Inventory inventory;
 final  List<InventoryItem>? _searchedItems;
@override List<InventoryItem>? get searchedItems {
  final value = _searchedItems;
  if (value == null) return null;
  if (_searchedItems is EqualUnmodifiableListView) return _searchedItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryStateCopyWith<_InventoryState> get copyWith => __$InventoryStateCopyWithImpl<_InventoryState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InventoryState'))
    ..add(DiagnosticsProperty('inventory', inventory))..add(DiagnosticsProperty('searchedItems', searchedItems));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryState&&(identical(other.inventory, inventory) || other.inventory == inventory)&&const DeepCollectionEquality().equals(other._searchedItems, _searchedItems));
}


@override
int get hashCode => Object.hash(runtimeType,inventory,const DeepCollectionEquality().hash(_searchedItems));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InventoryState(inventory: $inventory, searchedItems: $searchedItems)';
}


}

/// @nodoc
abstract mixin class _$InventoryStateCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory _$InventoryStateCopyWith(_InventoryState value, $Res Function(_InventoryState) _then) = __$InventoryStateCopyWithImpl;
@override @useResult
$Res call({
 Inventory inventory, List<InventoryItem>? searchedItems
});




}
/// @nodoc
class __$InventoryStateCopyWithImpl<$Res>
    implements _$InventoryStateCopyWith<$Res> {
  __$InventoryStateCopyWithImpl(this._self, this._then);

  final _InventoryState _self;
  final $Res Function(_InventoryState) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inventory = null,Object? searchedItems = freezed,}) {
  return _then(_InventoryState(
inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as Inventory,searchedItems: freezed == searchedItems ? _self._searchedItems : searchedItems // ignore: cast_nullable_to_non_nullable
as List<InventoryItem>?,
  ));
}


}

// dart format on
