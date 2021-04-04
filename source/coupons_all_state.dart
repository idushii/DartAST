
part of 'coupons_all_bloc.dart';

@immutable
class CouponsAllState {
  final List<Coupon> items;
  final MetaPage meta;
  final LoadStatusEnum loadStatus;
  final dynamic error;

  CouponsAllState({
    @required this.items,
    @required this.meta,
    @required this.loadStatus,
    @required this.error,
  });

  @override
  CouponsAllState copyWith({
    List<Coupon> items,
    MetaPage meta,
    LoadStatusEnum loadStatus,
    dynamic error,
  }) {
    return new CouponsAllState(
      items: items ?? this.items,
      meta: meta ?? this.meta,
      loadStatus: loadStatus ?? this.loadStatus,
      error: error ?? this.error,
    );
  }

  @override
  toMap() => {
    items.toString(),
    loadStatus.toString()
  };

  Coupon byId(int id) => items.firstWhere((element) => element.id == id);
  int get currentPage => meta?.currentPage ?? 1;
  bool get canLoadNext => (meta != null ? meta.lastPage > meta.currentPage : false)  && !processLoading;
  bool get loading => loadStatus == LoadStatusEnum.LOADING;
  bool get loadingNext => loadStatus == LoadStatusEnum.LOADING_NEXT;
  bool get processLoading => [LoadStatusEnum.LOADING, LoadStatusEnum.LOADING_NEXT, LoadStatusEnum.REFRESH, LoadStatusEnum.SEARCH].contains(loadStatus);
  bool get showList => [LoadStatusEnum.DONE, LoadStatusEnum.REFRESH, LoadStatusEnum.LOADING_NEXT].contains(loadStatus);
}
