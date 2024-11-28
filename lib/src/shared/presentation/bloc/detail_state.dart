part of 'detail_bloc.dart';

sealed class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

final class DetailInitial extends DetailState {}

class FavoriteLoadingDetail extends DetailState {}

class FavoriteSuccessDetail extends DetailState {}

class SuccesGetIdFavorite extends DetailState {
  final List<int> listIdFavorite;
  const SuccesGetIdFavorite({
    required this.listIdFavorite,
  });
}

class FavoriteFailure extends DetailState {
  final String error;
  const FavoriteFailure({required this.error});

  @override
  List<Object> get props => [error];
}
