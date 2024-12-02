// To parse this JSON data, do
//
//     final searchMovieModel = searchMovieModelFromJson(jsonString);

import 'package:equatable/equatable.dart';

// SearchMovieModel searchMovieModelFromJson(String str) => SearchMovieModel.fromJson(json.decode(str));

// String searchMovieModelToJson(SearchMovieModel data) => json.encode(data.toJson());

class SearchMovieModel extends Equatable {
  final String? query;
  final bool? includeAdult;
  final String? primaryReleaseYear;
  final int? page;
  final List<int>? genre;
  final String? region;
  final String? year;

  const SearchMovieModel({
    this.query,
    this.includeAdult,
    this.primaryReleaseYear,
    this.page = 1,
    this.genre,
    this.region,
    this.year,
  });

  @override
  List<Object?> get props => [
        query,
        includeAdult,
        primaryReleaseYear,
        page,
        genre,
        region,
        year,
      ];

  SearchMovieModel copyWith({
    String? query,
    bool? includeAdult,
    String? primaryReleaseYear,
    int? page,
    String? region,
    List<int>? genre,
    String? year,
  }) =>
      SearchMovieModel(
        query: query ?? this.query,
        includeAdult: includeAdult ?? this.includeAdult,
        primaryReleaseYear: primaryReleaseYear ?? this.primaryReleaseYear,
        page: page ?? this.page,
        genre: genre ?? this.genre,
        region: region ?? this.region,
        year: year ?? this.year,
      );
}
