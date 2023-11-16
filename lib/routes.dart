import 'package:disan/View/Screens/auth/complete_account_info.dart';
import 'package:disan/View/Screens/auth/login_page.dart';
import 'package:disan/View/Screens/auth/reset_password.dart';
import 'package:disan/View/Screens/auth/select_account_type.dart';
import 'package:disan/View/Screens/auth/signup.dart';
import 'package:disan/View/Screens/introduction_page.dart';
import 'package:disan/View/Screens/navbar/navbar.dart';
import 'package:disan/View/Screens/navbar/notifications/order_notifications_page.dart';
import 'package:disan/View/Screens/navbar/notifications/rating_notifications_page.dart';
import 'package:disan/View/Screens/navbar/search_page.dart';
import 'package:disan/View/Screens/navbar/shop/cart_page.dart';
import 'package:disan/View/Screens/navbar/shop/category_page.dart';
import 'package:disan/View/Screens/navbar/shop/orders_page.dart';
import 'package:disan/View/Screens/navbar/shop/product_details.dart';
import 'package:disan/View/Screens/navbar/clip/add_clip.dart';
import 'package:disan/View/Screens/navbar/timeline/comments_page.dart';
import 'package:disan/View/Screens/navbar/timeline/create_post_page.dart';
import 'package:disan/View/Screens/navbar/timeline/story/story_view_page.dart';
import 'package:disan/View/Screens/user/block_list.dart';
import 'package:disan/View/Screens/user/choose_language.dart';
import 'package:disan/View/Screens/user/settings.dart';
import 'package:disan/View/Screens/user/user_profile.dart';
import 'package:disan/View/Widgets/google_maps_window.dart';
import 'package:disan/View/Widgets/timelineWidgets/img_view.dart';
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
  static String productDetails = '/pdetails';
  static String cart = '/cart';
  static String orders = '/orders';
  static String myOrders = '/myorders';
  static String myRatings = '/myratings';
  static String viewStory = '/viewstory';
  static String createClip = '/createclip';
  static String search = '/search';
  static String settings = '/settings';
  static String block = '/block';
  static String lang = '/lang';
  static String imgview = "/imgview";
  static String category = "/cat";
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
  GetPage(
    name: Routes.comments,
    page: () => CommentsPage(),
  ),
  GetPage(
    name: Routes.productDetails,
    page: () => ProductDetailsPage(),
  ),
  GetPage(
    name: Routes.cart,
    page: () => CartPage(),
  ),
  GetPage(
    name: Routes.orders,
    page: () => OrdersPage(),
  ),
  GetPage(
    name: Routes.myOrders,
    page: () => MyOrdersPage(),
  ),
  GetPage(
    name: Routes.myRatings,
    page: () => MyRatingsPage(),
  ),
  GetPage(
    name: Routes.viewStory,
    page: () => StoryViewPage(),
  ),
  GetPage(
    name: Routes.createClip,
    page: () => AddClipPage(),
  ),
  GetPage(
    name: Routes.search,
    page: () => SearchPage(),
  ),
  GetPage(
    name: Routes.settings,
    page: () => SettingsPage(),
  ),
  GetPage(
    name: Routes.block,
    page: () => BlockList(),
  ),
  GetPage(
    name: Routes.lang,
    page: () => ChooseLangPage(),
  ),
  GetPage(
    name: Routes.imgview,
    page: () => const ImgView(),
  ),
  GetPage(
    name: Routes.category,
    page: () => CategoryPage(),
  ),
];
