// To parse this JSON data, do
//
//     final searchMovieModel = searchMovieModelFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

SearchMovieModel searchMovieModelFromJson(String str) => SearchMovieModel.fromJson(json.decode(str));

String searchMovieModelToJson(SearchMovieModel data) => json.encode(data.toJson());

class SearchMovieModel extends Equatable {
  final String? query;
  final bool? includeAdult;
  final String? primaryReleaseYear;
  final int? page;
  final String? region;
  final String? year;

  const SearchMovieModel({
    this.query,
    this.includeAdult,
    this.primaryReleaseYear,
    this.page,
    this.region,
    this.year,
  });

  SearchMovieModel copyWith({
    String? query,
    bool? includeAdult,
    String? primaryReleaseYear,
    int? page,
    String? region,
    String? year,
  }) =>
      SearchMovieModel(
        query: query ?? this.query,
        includeAdult: includeAdult ?? this.includeAdult,
        primaryReleaseYear: primaryReleaseYear ?? this.primaryReleaseYear,
        page: page ?? this.page,
        region: region ?? this.region,
        year: year ?? this.year,
      );

  factory SearchMovieModel.fromJson(Map<String, dynamic> json) => SearchMovieModel(
        query: json["query"],
        includeAdult: json["include_adult"],
        primaryReleaseYear: json["primary_release_year"],
        page: json["page"],
        region: json["region"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "query": query,
        "include_adult": includeAdult,
        "primary_release_year": primaryReleaseYear,
        "page": page,
        "region": region,
        "year": year,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        query,
        includeAdult,
        primaryReleaseYear,
        page,
        region,
        year,
      ];
}
