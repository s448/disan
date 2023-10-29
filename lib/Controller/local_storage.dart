import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsController extends GetxController {
  final prefs = Get.find<SharedPreferences>();

  Future<void> saveUserCredentials(String userId, String userEmail) async {
    await prefs.setString('userId', userId);
    await prefs.setString('userEmail', userEmail);
  }

  markIntroAsDone() async {
    await prefs.setBool("intro", true);
  }

  isIntroDone() {
    prefs.getBool('intro');
  }

  String getItem(String id) {
    return prefs.getString(id) ?? '';
  }

  Future<void> clearUserCredentials() async {
    await prefs.remove('userId');
    await prefs.remove('userEmail');
  }

  //if true then user is authorized
  bool userAuthenticated() {
    String phone = getItem('userId');
    String verificationId = getItem('userEmail');

    if (phone == '' || verificationId == '') {
      // if (kDebugMode) {
      //    print(false);
      // }
      return false;
    } else {
      // if (kDebugMode) {
      //   print(true);
      // }
      return true;
    }
  }
}
