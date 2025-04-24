import 'package:get/get.dart';

import '../presentation/auth_screens/login_screen.dart';
import '../presentation/dashboard/dashboard_sceen.dart';
import '../presentation/dashboard/stores/stores_screen.dart';
import '../presentation/home_screen.dart';
import '../presentation/splash_screen.dart';

abstract class AppScreens {
  static const root = '/';
  static const home = '/home';
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const allStores = '/allstores';
}

abstract class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppScreens.root,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: AppScreens.home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: AppScreens.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppScreens.dashboard,
      page: () => const DashboardScreen(),
    ),
    GetPage(
      name: AppScreens.allStores,
      page: () => StoresScreen(),
    ),
  ];
}
