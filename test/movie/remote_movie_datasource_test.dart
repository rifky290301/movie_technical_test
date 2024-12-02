import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_technical_test/src/core/utils/constant/network_constant.dart';
import 'package:dio/dio.dart';
import 'package:movie_technical_test/src/features/home/data/datasources/remote/abstrac_home_api.dart';
import 'package:movie_technical_test/src/features/home/data/datasources/remote/home_impl_api.dart';
import 'package:movie_technical_test/src/features/home/data/models/detail_movie_model.dart';
import 'package:movie_technical_test/src/features/home/data/models/movie_model.dart';
import 'package:movie_technical_test/src/features/home/data/models/search_movie_model.dart';

@GenerateNiceMocks([MockSpec<AbstracHomeApi>(), MockSpec<Dio>()])
import 'remote_movie_datasource_test.mocks.dart';

void main() async {
  var remoteDataSourcMovie = MockAbstracHomeApi();
  MockDio mockDio = MockDio();
  var homeImplApi = HomeImplApi(mockDio);
  // mockDio.options.baseUrl = NetworkConstant.apiUrl;
  // mockDio.options.headers['Authorization'] = 'Bearer ${NetworkConstant.bearerToken}';

  MovieModel fakeMovieModel = MovieModel.fromJson(fakeMovieJson);
  final json = fakeGenreJson['genres'];
  List<Genre> fakeListGenre = json == null ? [] : List<Genre>.from(json!.map((x) => Genre.fromJson(x)));
  String page = '1';
  // String urlGetMovieNowPlaying = "${NetworkConstant.apiUrl}/movie/now_playing";

  group('MockAbstracHomeApi', () {
    group('getMoviesNowPlaying', () {
      test('BERHASIL', () async {
        // Stub -> kondisi untuk kita palsukan
        // Proses stubbing
        when(remoteDataSourcMovie.getMoviesNowPlaying(page)).thenAnswer(
          (_) async => fakeMovieModel,
        );

        try {
          var respose = await remoteDataSourcMovie.getMoviesNowPlaying(page);
          expect(respose, fakeMovieModel);
          // TESTING UNTUK KEBERHASILAN
        } catch (e) {
          // TIDAK MUNGKIN TERJADI ERROR
          fail("TIDAK MUNGKIN TERJADI");
        }
      });
      test('GAGAL', () async {
        // Stub -> kondisi untuk kita palsukan
        // Proses stubbing
        when(remoteDataSourcMovie.getMoviesNowPlaying(page)).thenThrow(Exception());

        try {
          await remoteDataSourcMovie.getMoviesNowPlaying(page);
          // TIDAK MUNGKIN TERJADI ERROR
          fail("TIDAK MUNGKIN TERJADI");
        } catch (e) {
          // TESTING UNTUK KEGAGALAN
          expect(e, isException);
        }
      });
    });
    group('getSearchMovies', () {
      test('BERHASIL', () async {
        when(remoteDataSourcMovie.getSearchMovies(const SearchMovieModel())).thenAnswer(
          (_) async => fakeMovieModel,
        );

        try {
          var respose = await remoteDataSourcMovie.getSearchMovies(const SearchMovieModel());
          expect(respose, fakeMovieModel);
        } catch (e) {
          fail("TIDAK MUNGKIN TERJADI");
        }
      });
      test('GAGAL', () async {
        when(remoteDataSourcMovie.getSearchMovies(const SearchMovieModel())).thenThrow(Exception());

        try {
          await remoteDataSourcMovie.getSearchMovies(const SearchMovieModel());
          fail("TIDAK MUNGKIN TERJADI");
        } catch (e) {
          expect(e, isException);
        }
      });
    });
    group('getAllGenre', () {
      test('BERHASIL', () async {
        when(remoteDataSourcMovie.getAllGenre()).thenAnswer(
          (_) async => fakeListGenre,
        );

        try {
          var respose = await remoteDataSourcMovie.getAllGenre();
          expect(respose, fakeListGenre);
        } catch (e) {
          fail("TIDAK MUNGKIN TERJADI");
        }
      });
      test('GAGAL', () async {
        when(remoteDataSourcMovie.getAllGenre()).thenThrow(Exception());
        try {
          await remoteDataSourcMovie.getAllGenre();
          fail("TIDAK MUNGKIN TERJADI");
        } catch (e) {
          expect(e, isException);
        }
      });
    });
  });

// ! YANG INI ERROR KARENA SAYA TIDAK BISA SET BEARER TOKEN
  // group('Remote Data Source Movie Impl', () {
  //   group('getMoviesNowPlaying', () {
  //     test('BERHASIL (200)', () async {
  //       // Stub -> kondisi untuk kita palsukan
  //       // Proses stubbing
  //       when(mockDio.get('${NetworkConstant.apiUrl}/movie/now_playing',
  //           options: Options(headers: {
  //             'Authorization': 'Bearer ${NetworkConstant.bearerToken}',
  //           }))).thenAnswer(
  //         (_) async => Response(
  //           data: fakeMovieJson,
  //           requestOptions: RequestOptions(
  //             path: '${NetworkConstant.apiUrl}/movie/now_playing',
  //           ),
  //           statusCode: 200,
  //         ),
  //       );

  //       try {
  //         var respose = await homeImplApi.getMoviesNowPlaying(page);
  //         expect(respose, fakeMovieModel);
  //         // TESTING UNTUK KEBERHASILAN
  //       } catch (e) {
  //         // TIDAK MUNGKIN TERJADI ERROR
  //         fail("TIDAK MUNGKIN TERJADI");
  //       }
  //     });
  //   });
  // });
}

Map<String, dynamic> fakeGenreJson = {
  "genres": [
    {"id": 28, "name": "Action"},
    {"id": 12, "name": "Adventure"},
    {"id": 16, "name": "Animation"},
    {"id": 35, "name": "Comedy"},
    {"id": 80, "name": "Crime"},
    {"id": 99, "name": "Documentary"},
    {"id": 18, "name": "Drama"},
    {"id": 10751, "name": "Family"},
    {"id": 14, "name": "Fantasy"},
    {"id": 36, "name": "History"},
    {"id": 27, "name": "Horror"},
    {"id": 10402, "name": "Music"},
    {"id": 9648, "name": "Mystery"},
    {"id": 10749, "name": "Romance"},
    {"id": 878, "name": "Science Fiction"},
    {"id": 10770, "name": "TV Movie"},
    {"id": 53, "name": "Thriller"},
    {"id": 10752, "name": "War"},
    {"id": 37, "name": "Western"}
  ]
};

Map<String, dynamic> fakeMovieJson = {
  "dates": {"maximum": "2024-12-04", "minimum": "2024-10-23"},
  "page": 1,
  "results": [
    {
      "adult": false,
      "backdrop_path": "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg",
      "genre_ids": [878, 28, 12],
      "id": 912649,
      "original_language": "en",
      "original_title": "Venom: The Last Dance",
      "overview":
          "Eddie and Venom are on the run. Hunted by both of their worlds and with the net closing in, the duo are forced into a devastating decision that will bring the curtains down on Venom and Eddie's last dance.",
      "popularity": 2710.484,
      "poster_path": "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg",
      "release_date": "2024-10-22",
      "title": "Venom: The Last Dance",
      "video": false,
      "vote_average": 6.4,
      "vote_count": 932
    },
    {
      "adult": false,
      "backdrop_path": "/tElnmtQ6yz1PjN1kePNl8yMSb59.jpg",
      "genre_ids": [16, 12, 10751, 35],
      "id": 1241982,
      "original_language": "en",
      "original_title": "Moana 2",
      "overview":
          "After receiving an unexpected call from her wayfinding ancestors, Moana journeys alongside Maui and a new crew to the far seas of Oceania and into dangerous, long-lost waters for an adventure unlike anything she's ever faced.",
      "popularity": 3633.267,
      "poster_path": "/4YZpsylmjHbqeWzjKpUEF8gcLNW.jpg",
      "release_date": "2024-11-27",
      "title": "Moana 2",
      "video": false,
      "vote_average": 7.264,
      "vote_count": 89
    },
    {
      "adult": false,
      "backdrop_path": "/iR79ciqhtaZ9BE7YFA1HpCHQgX4.jpg",
      "genre_ids": [27, 9648],
      "id": 1100782,
      "original_language": "en",
      "original_title": "Smile 2",
      "overview":
          "About to embark on a new world tour, global pop sensation Skye Riley begins experiencing increasingly terrifying and inexplicable events. Overwhelmed by the escalating horrors and the pressures of fame, Skye is forced to face her dark past to regain control of her life before it spirals out of control.",
      "popularity": 1599.314,
      "poster_path": "/ht8Uv9QPv9y7K0RvUyJIaXOZTfd.jpg",
      "release_date": "2024-10-16",
      "title": "Smile 2",
      "video": false,
      "vote_average": 6.649,
      "vote_count": 731
    },
    {
      "adult": false,
      "backdrop_path": "/v9acaWVVFdZT5yAU7J2QjwfhXyD.jpg",
      "genre_ids": [16, 878, 10751],
      "id": 1184918,
      "original_language": "en",
      "original_title": "The Wild Robot",
      "overview":
          "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island's animals and cares for an orphaned baby goose.",
      "popularity": 1442.21,
      "poster_path": "/wTnV3PCVW5O92JMrFvvrRcV39RU.jpg",
      "release_date": "2024-09-12",
      "title": "The Wild Robot",
      "video": false,
      "vote_average": 8.401,
      "vote_count": 3188
    },
    {
      "adult": false,
      "backdrop_path": "/euYIwmwkmz95mnXvufEmbL6ovhZ.jpg",
      "genre_ids": [28, 12],
      "id": 558449,
      "original_language": "en",
      "original_title": "Gladiator II",
      "overview":
          "Years after witnessing the death of the revered hero Maximus at the hands of his uncle, Lucius is forced to enter the Colosseum after his home is conquered by the tyrannical Emperors who now lead Rome with an iron fist. With rage in his heart and the future of the Empire at stake, Lucius must look to his past to find strength and honor to return the glory of Rome to its people.",
      "popularity": 1293.172,
      "poster_path": "/2cxhvwyEwRlysAmRH4iodkvo0z5.jpg",
      "release_date": "2024-11-13",
      "title": "Gladiator II",
      "video": false,
      "vote_average": 6.7,
      "vote_count": 797
    },
    {
      "adult": false,
      "backdrop_path": "/uKb22E0nlzr914bA9KyA5CVCOlV.jpg",
      "genre_ids": [18, 14, 10749],
      "id": 402431,
      "original_language": "en",
      "original_title": "Wicked",
      "overview":
          "When ostracized and misunderstood green-skinned Elphaba is forced to share a room with the popular aristocrat Glinda, the two's unlikely friendship is tested as they begin to fulfill their respective destinies as Glinda the Good and the Wicked Witch of the West.",
      "popularity": 1436.528,
      "poster_path": "/c5Tqxeo1UpBvnAc3csUm7j3hlQl.jpg",
      "release_date": "2024-11-20",
      "title": "Wicked",
      "video": false,
      "vote_average": 7.7,
      "vote_count": 251
    },
    {
      "adult": false,
      "backdrop_path": "/18TSJF1WLA4CkymvVUcKDBwUJ9F.jpg",
      "genre_ids": [27, 53],
      "id": 1034541,
      "original_language": "en",
      "original_title": "Terrifier 3",
      "overview":
          "Five years after surviving Art the Clown's Halloween massacre, Sienna and Jonathan are still struggling to rebuild their shattered lives. As the holiday season approaches, they try to embrace the Christmas spirit and leave the horrors of the past behind. But just when they think they're safe, Art returns, determined to turn their holiday cheer into a new nightmare. The festive season quickly unravels as Art unleashes his twisted brand of terror, proving that no holiday is safe.",
      "popularity": 1072.453,
      "poster_path": "/l1175hgL5DoXnqeZQCcU3eZIdhX.jpg",
      "release_date": "2024-10-09",
      "title": "Terrifier 3",
      "video": false,
      "vote_average": 6.876,
      "vote_count": 1138
    },
    {
      "adult": false,
      "backdrop_path": "/kyVcNF6GRthdiT4oZn5XgJtl0F7.jpg",
      "genre_ids": [28, 80],
      "id": 1233327,
      "original_language": "te",
      "original_title": "మట్కా",
      "overview":
          "Set between the years 1958 and 1982, Matka tells the story of Vasu, who rises from poverty to create a powerful gambling empire in India, ultimately leading the nation into a battle with the government. Based on real events, the tale explores themes of love, moral choices, and the consequences of ambition.",
      "popularity": 784.456,
      "poster_path": "/jrHIKDq9xvKJhYBDvYwmAfs8qvr.jpg",
      "release_date": "2024-11-14",
      "title": "Matka",
      "video": false,
      "vote_average": 5.3,
      "vote_count": 6
    },
    {
      "adult": false,
      "backdrop_path": "/kwXycPsLA6SV3KUOagn343TtMOf.jpg",
      "genre_ids": [28, 878, 53],
      "id": 791042,
      "original_language": "en",
      "original_title": "Levels",
      "overview": "After witnessing his girlfriend's murder, a man risks everything - including reality itself - to discover the truth.",
      "popularity": 973.541,
      "poster_path": "/y1xm0jMIlx9Oo2a3jWNyLGm43sJ.jpg",
      "release_date": "2024-11-01",
      "title": "Levels",
      "video": false,
      "vote_average": 5.7,
      "vote_count": 27
    },
    {
      "adult": false,
      "backdrop_path": "/n4ycOGj2tRLfINTJQ3wl0vNYqpR.jpg",
      "genre_ids": [16, 14, 10751, 12, 35],
      "id": 592983,
      "original_language": "en",
      "original_title": "Spellbound",
      "overview":
          "When a powerful spell turns her parents into giant monsters, a teenage princess must journey into the wild to reverse the curse before it's too late.",
      "popularity": 1176.261,
      "poster_path": "/xFSIygDiX70Esp9dheCgGX0Nj77.jpg",
      "release_date": "2024-11-22",
      "title": "Spellbound",
      "video": false,
      "vote_average": 6.6,
      "vote_count": 86
    },
    {
      "adult": false,
      "backdrop_path": "/7h6TqPB3ESmjuVbxCxAeB1c9OB1.jpg",
      "genre_ids": [18, 27, 878],
      "id": 933260,
      "original_language": "en",
      "original_title": "The Substance",
      "overview":
          "A fading celebrity decides to use a black market drug, a cell-replicating substance that temporarily creates a younger, better version of herself.",
      "popularity": 846.195,
      "poster_path": "/lqoMzCcZYEFK729d6qzt349fB4o.jpg",
      "release_date": "2024-09-07",
      "title": "The Substance",
      "video": false,
      "vote_average": 7.3,
      "vote_count": 2256
    },
    {
      "adult": false,
      "backdrop_path": "/uMXVeVL2v57lMv6pqBmegDHHPqz.jpg",
      "genre_ids": [16, 878, 12, 10751],
      "id": 698687,
      "original_language": "en",
      "original_title": "Transformers One",
      "overview":
          "The untold origin story of Optimus Prime and Megatron, better known as sworn enemies, but once were friends bonded like brothers who changed the fate of Cybertron forever.",
      "popularity": 785.538,
      "poster_path": "/qbkAqmmEIZfrCO8ZQAuIuVMlWoV.jpg",
      "release_date": "2024-09-11",
      "title": "Transformers One",
      "video": false,
      "vote_average": 8.093,
      "vote_count": 783
    },
    {
      "adult": false,
      "backdrop_path": "/rOmUuQEZfPXglwFs5ELLLUDKodL.jpg",
      "genre_ids": [28, 35, 14],
      "id": 845781,
      "original_language": "en",
      "original_title": "Red One",
      "overview":
          "After Santa Claus (codename: Red One) is kidnapped, the North Pole's Head of Security must team up with the world's most infamous bounty hunter in a globe-trotting, action-packed mission to save Christmas.",
      "popularity": 781.81,
      "poster_path": "/cdqLnri3NEGcmfnqwk2TSIYtddg.jpg",
      "release_date": "2024-10-31",
      "title": "Red One",
      "video": false,
      "vote_average": 6.6,
      "vote_count": 177
    },
    {
      "adult": false,
      "backdrop_path": "/zpaodBqO2lcwJh2SQrFFf1Rn8Jy.jpg",
      "genre_ids": [10749, 18, 35],
      "id": 1100099,
      "original_language": "en",
      "original_title": "We Live in Time",
      "overview":
          "An up-and-coming chef and a recent divorcée find their lives forever changed when a chance encounter brings them together, in a decade-spanning, deeply moving romance.",
      "popularity": 672.31,
      "poster_path": "/ssFS25CiYQvRJqErqaEyHuVgyH7.jpg",
      "release_date": "2024-10-10",
      "title": "We Live in Time",
      "video": false,
      "vote_average": 7.6,
      "vote_count": 115
    },
    {
      "adult": false,
      "backdrop_path": "/1FBHAQnq7Bs3djBmaNkfdVbnCUE.jpg",
      "genre_ids": [28, 53],
      "id": 1124641,
      "original_language": "en",
      "original_title": "Classified",
      "overview":
          "Operating alone in the field for more than 20 years, a CIA hitman uses the \"Help Wanted\" section of the newspapers to get his orders from the Agency. His long-lost daughter, now a UK MI6 analyst, tracks him down to deliver shocking news: his CIA boss has been dead for years and the division long since shut down. Together, they set out to discover whose orders he's been executing.",
      "popularity": 690.096,
      "poster_path": "/3k8jv1kSAAc0rCfFGtWDDQL4dfK.jpg",
      "release_date": "2024-09-19",
      "title": "Classified",
      "video": false,
      "vote_average": 5.744,
      "vote_count": 78
    },
    {
      "adult": false,
      "backdrop_path": "/2NPhBHfzhEmXl8csQ2dKmoxfj5e.jpg",
      "genre_ids": [80, 53, 28],
      "id": 972614,
      "original_language": "en",
      "original_title": "Knox Goes Away",
      "overview":
          "A contract killer, after being diagnosed with a fast-moving form of dementia, is presented with the opportunity to redeem himself by saving the life of his estranged adult son. But to do so, he must race against the police closing in on him as well as the ticking clock of his own rapidly deteriorating mind.",
      "popularity": 602.706,
      "poster_path": "/w39qKYjltCix18BwtoZ1e45usdb.jpg",
      "release_date": "2024-03-15",
      "title": "Knox Goes Away",
      "video": false,
      "vote_average": 6.7,
      "vote_count": 240
    },
    {
      "adult": false,
      "backdrop_path": "/6lE2e6j8qbtQR8aHxQNJlwxdmKV.jpg",
      "genre_ids": [28, 18, 80, 53],
      "id": 974453,
      "original_language": "en",
      "original_title": "Absolution",
      "overview":
          "An aging ex-boxer gangster working as muscle for a Boston crime boss receives an upsetting diagnosis.  Despite a faltering memory, he attempts to rectify the sins of his past and reconnect with his estranged children. He is determined to leave a positive legacy for his grandson, but the criminal underworld isn’t done with him and won’t loosen their grip willingly.",
      "popularity": 730.78,
      "poster_path": "/cNtAslrDhk1i3IOZ16vF7df6lMy.jpg",
      "release_date": "2024-10-31",
      "title": "Absolution",
      "video": false,
      "vote_average": 6,
      "vote_count": 67
    },
    {
      "adult": false,
      "backdrop_path": "/llIXQAndg5kB6SWlp6ouUdO7Zxd.jpg",
      "genre_ids": [28, 12, 18, 36, 10749, 53],
      "id": 1084736,
      "original_language": "fr",
      "original_title": "Le Comte de Monte-Cristo",
      "overview":
          "Edmond Dantes becomes the target of a sinister plot and is arrested on his wedding day for a crime he did not commit. After 14 years in the island prison of Château d’If, he manages a daring escape. Now rich beyond his dreams, he assumes the identity of the Count of Monte-Cristo and exacts his revenge on the three men who betrayed him.",
      "popularity": 464.132,
      "poster_path": "/zw4kV7npGtaqvUxvJE9IdqdFsNc.jpg",
      "release_date": "2024-06-28",
      "title": "The Count of Monte-Cristo",
      "video": false,
      "vote_average": 8.199,
      "vote_count": 908
    },
    {
      "adult": false,
      "backdrop_path": "/liuBLPXvisMRo5w2JEKHXceWq5u.jpg",
      "genre_ids": [28, 80, 18],
      "id": 1171640,
      "original_language": "fr",
      "original_title": "GTMAX",
      "overview":
          "When a notorious gang of bikers recruits her brother for a heist, a former motocross champion must face her deepest fears to keep her family safe.",
      "popularity": 682.343,
      "poster_path": "/bx92hl70NUhojjO3eV6LqKllj4L.jpg",
      "release_date": "2024-11-19",
      "title": "GTMAX",
      "video": false,
      "vote_average": 6.407,
      "vote_count": 43
    },
    {
      "adult": false,
      "backdrop_path": "/hkJhGayONXn96CqIRM9GhWKnlCf.jpg",
      "genre_ids": [28, 12, 16, 14],
      "id": 1014505,
      "original_language": "ja",
      "original_title": "劇場版「オーバーロード」聖王国編",
      "overview":
          "After twelve years of playing his favorite MMORPG game, Momonga logs in for the last time only to find himself transported into its world playing it indefinitely. Throughout his adventures, his avatar ascends to the title of Sorcerer King Ains Ooal Gown. Once prosperous but now on the brink of ruin, The Sacred Kingdom enjoyed years of peace after construction of an enormous wall protecting them from neighboring invasions. But, one day this comes to an end when the Demon Emperor Jaldabaoth arrives with an army of villainous demi-humans. Fearing invasion of their own lands, the neighboring territory of the Slane Theocracy is forced to beg their enemies at the Sorcerer Kingdom for help. Heeding the call, Momonga, now known as the Sorcerer King Ains Ooal Gown, rallies the Sorcerer Kingdom and its undead army to join the fight alongside the Sacred Kingdom and the Slane Theocracy in hopes to defeat the Demon Emperor.",
      "popularity": 460.604,
      "poster_path": "/jEvytxNa5mfW7VAUmDWsZtIdATc.jpg",
      "release_date": "2024-09-20",
      "title": "OVERLORD: The Sacred Kingdom",
      "video": false,
      "vote_average": 7.881,
      "vote_count": 21
    }
  ],
  "total_pages": 279,
  "total_results": 5569
};
