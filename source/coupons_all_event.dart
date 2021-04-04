
part of 'coupons_all_bloc.dart';

@immutable
abstract class CouponsAllEvent {
  const CouponsAllEvent();
}

class CouponsAllLoadingEvent extends CouponsAllEvent {}

class CouponsAllLoadedEvent extends CouponsAllEvent {
  final List<Coupon> items;
  final MetaPage meta;

  CouponsAllLoadedEvent({
    @required this.items,
    @required this.meta,
  });

  @override
  String toString() => "items=$items.toString(), meta=$meta.toString()";
}

class CouponsAllLoadingNextEvent extends CouponsAllEvent {}

class CouponsAllLoadFailEvent extends CouponsAllEvent {
  final dynamic error;

  CouponsAllLoadFailEvent({
    @required this.error,
  });

  @override
  String toString() => "error=$error.toString()";
}
