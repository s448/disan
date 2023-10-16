import 'package:get/get.dart';

class AuthController extends GetxController {
  var email = "".obs;
  var name = "".obs;
  var password = "".obs;
  var rememberMe = false.obs;
  var textObsecured = true.obs;

  changeObscureTextStatus() {
    textObsecured.value = !textObsecured.value;
    update();
  }
}
