import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/favorite/favorite_injection.dart';
import '../../features/home/home_injection.dart';
import '../../shared/app_injections.dart';
import '../network/dio_network.dart';
import 'log/app_logger.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  await initSharedPrefsInjections();
  await initAppInjections();
  await initDioInjections();
  await initFeatureInjection();
}

initSharedPrefsInjections() async {
  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  await sl.isReady<SharedPreferences>();
}

Future<void> initDioInjections() async {
  initRootLogger();
  DioNetwork.initDio();
}

initFeatureInjection() async {
  await initHomeInjection();
  await initFavoriteInjection();
}
