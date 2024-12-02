import 'package:dio/dio.dart';

import '../../../../../core/network/error/dio_error_handler.dart';
import '../../../../../core/network/error/exceptions.dart';
import '../../models/detail_movie_model.dart';
import '../../models/movie_model.dart';
import '../../models/search_movie_model.dart';
import 'abstrac_home_api.dart';

class HomeImplApi extends AbstracHomeApi {
  final Dio dio;

  HomeImplApi(this.dio);

  @override
  Future<List<Genre>> getAllGenre() async {
    try {
      final result = await dio.get(
        '/genre/movie/list',
      );
      List<Genre> genres = [];
      if (result.data != null) {
        final json = result.data['genres'];
        genres = json == null ? [] : List<Genre>.from(json!.map((x) => Genre.fromJson(x)));
      }
      return genres;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw CancelTokenException(handleDioError(e), e.response?.statusCode);
      } else {
        throw ServerException(handleDioError(e), e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<DetailMovieModel> getDetailMovie(String params) async {
    try {
      final result = await dio.get(
        '/$params/movie',
      );
      var detailMovieModel = const DetailMovieModel();
      if (result.data != null) {
        final data = result.data as Map<String, dynamic>;
        detailMovieModel = DetailMovieModel.fromJson(data);
      }
      return detailMovieModel;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw CancelTokenException(handleDioError(e), e.response?.statusCode);
      } else {
        throw ServerException(handleDioError(e), e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<MovieModel> getMoviesNowPlaying(String params) async {
    try {
      final Response result = await dio.get(
        '/movie/now_playing',
        queryParameters: {
          'language': 'en-US',
          'page': params,
        },
      );
      MovieModel? movieModel;
      if (result.data != null) {
        final data = result.data as Map<String, dynamic>;
        movieModel = MovieModel.fromJson(data);
      }
      return movieModel ?? const MovieModel();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw CancelTokenException(handleDioError(e), e.response?.statusCode);
      } else {
        throw ServerException(handleDioError(e), e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<MovieModel> getMoviesUpcomming(String params) async {
    try {
      final result = await dio.get(
        '/movie/upcoming',
        queryParameters: {
          'language': 'en-US',
          'page': params,
        },
      );
      MovieModel? movieModel;
      if (result.data != null) {
        final data = result.data as Map<String, dynamic>;
        movieModel = MovieModel.fromJson(data);
      }
      return movieModel ?? const MovieModel();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw CancelTokenException(handleDioError(e), e.response?.statusCode);
      } else {
        throw ServerException(handleDioError(e), e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }

  @override
  Future<MovieModel> getSearchMovies(SearchMovieModel params) async {
    try {
      final result = await dio.get(
        '/${params.genre == null ? 'search' : 'discover'}/movie',
        queryParameters: {
          'query': params.query,
          'page': params.page,
          'with_genres': params.genre?.map((e) => '$e').toList(),
        },
      );
      var movieModel = const MovieModel();
      if (result.data != null) {
        final data = result.data as Map<String, dynamic>;
        movieModel = MovieModel.fromJson(data);
      }
      return movieModel;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw CancelTokenException(handleDioError(e), e.response?.statusCode);
      } else {
        throw ServerException(handleDioError(e), e.response?.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString(), null);
    }
  }
}
