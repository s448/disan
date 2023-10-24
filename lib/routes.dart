import 'package:disan/View/Screens/auth/complete_account_info.dart';
import 'package:disan/View/Screens/auth/login_page.dart';
import 'package:disan/View/Screens/auth/reset_password.dart';
import 'package:disan/View/Screens/auth/select_account_type.dart';
import 'package:disan/View/Screens/auth/signup.dart';
import 'package:disan/View/Screens/introduction_page.dart';
import 'package:disan/View/Screens/navbar/navbar.dart';
import 'package:disan/View/Screens/navbar/timeline/comments_page.dart';
import 'package:disan/View/Screens/navbar/timeline/create_post_page.dart';
import 'package:disan/View/Screens/user/user_profile.dart';
import 'package:disan/View/Widgets/google_maps_window.dart';
import 'package:get/get.dart';

class Routes {
  static String introScreen = "/intro";
  static String login = '/login';
  static String signup = '/signup';
  static String reset = '/reset';
  static String navbar = '/navbar';
  static String selectAccType = "/acctype";
  static String completeUserInfo = "/CompleteAccountInfo";
  static String maps = "/maps";
  static String profile = "/profile";
  static String createPost = '/createpost';
  static String comments = '/comments';
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
  GetPage(
    name: Routes.completeUserInfo,
    page: () => CompleteAccountInfo(),
  ),
  GetPage(
    name: Routes.maps,
    page: () => MapPicker(),
  ),
  GetPage(
    name: Routes.introScreen,
    page: () => const IntroductionPage(),
  ),
  GetPage(
    name: Routes.profile,
    page: () => ProfilePage(),
  ),
  GetPage(
    name: Routes.createPost,
    page: () => CreatePostPage(),
  ),
  GetPage(name: Routes.comments, page: () => CommentsPage())
];
