import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../Documents/itMegaInsight1/lib/imports.dart';
import 'package:meta/meta.dart';

part 'coupons_all_event.dart';

part 'coupons_all_state.dart';

class CouponsAllBloc extends Bloc<CouponsAllEvent, CouponsAllState> {
  CouponsAllBloc()
      : super(CouponsAllState(items: [],
      meta: null,
      loadStatus: LoadStatusEnum.INIT,
      error: null));

  @override
  Stream<CouponsAllState> mapEventToState(CouponsAllEvent event) async* {
    if (event is CouponsAllLoadingEvent) {
      yield state.copyWith(
        loadStatus: LoadStatusEnum.LOADING,
        items: [],
        error: null,
      );
      final res = await getDemoItems(count: 5);
      add(CouponsAllLoadedEvent(items: res.items, meta: res.meta));
    }

    if (event is CouponsAllLoadedEvent) {
      yield state.copyWith(
        loadStatus: LoadStatusEnum.DONE,
        items: event.items,
        meta: event.meta,
      );
    }

    if (event is CouponsAllLoadingNextEvent) {
      yield state.copyWith(
        loadStatus: LoadStatusEnum.LOADING_NEXT,
        error: null,
      );
      final res = await getDemoItems(count: 5, currentPage: state.currentPage + 1);
      add(CouponsAllLoadedEvent(
          items: [...state.items, ...res.items], meta: res.meta));
    }

    if (event is CouponsAllLoadFailEvent) {
      yield state.copyWith(
        loadStatus: LoadStatusEnum.ERROR,
        items: [],
      );
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    add(CouponsAllLoadFailEvent(error: error.toString()));
    super.onError(error, stackTrace);
  }
}
