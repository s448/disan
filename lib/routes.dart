import 'package:disan/View/Screens/auth/login_page.dart';
import 'package:disan/View/Screens/auth/reset_password.dart';
import 'package:disan/View/Screens/auth/select_account_type.dart';
import 'package:disan/View/Screens/auth/signup.dart';
import 'package:disan/View/Screens/navbar/navbar.dart';
import 'package:get/get.dart';

class Routes {
  static String login = '/login';
  static String signup = '/signup';
  static String reset = '/reset';
  static String navbar = '/navbar';
  static String selectAccType = "/acctype";
}

final getPages = [
  GetPage(
    name: Routes.login,
    page: () => LoginPage(),
  ),
  GetPage(
    name: Routes.signup,
    page: () => SignUpPage(),
  ),
  GetPage(
    name: Routes.reset,
    page: () => ResetPasswordPage(),
  ),
  GetPage(
    name: Routes.navbar,
    page: () => const NavBar(),
  ),
  GetPage(
    name: Routes.selectAccType,
    page: () => SelectAccountTypePage(),
  ),
];
