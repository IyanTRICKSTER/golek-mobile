import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:golek_mobile/storage/sharedpreferences_manager.dart';

GetIt locator = GetIt.instance;

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }
}

Future<void> setupInjector() async {
  //storage
  SharedPreferencesManager sharedPreferencesManager = await SharedPreferencesManager.getInstance();

  locator.registerSingleton<SharedPreferencesManager>(sharedPreferencesManager);
  locator.registerLazySingleton(() => NavigationService());
}
