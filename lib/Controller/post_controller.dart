import 'package:audioplayers/audioplayers.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  RxBool isPlaying = false.obs;
  final player = AudioPlayer();

  final userController = Get.find<UserController>();
  RxBool isLiked = false.obs;

  triggerLike(DanModel dan) {
    String myId = userController.curentUserModel.id!;

    if (dan.likers!.contains(myId)) {
      isLiked.value = true;
    } else {
      isLiked.value = false;
    }
    update();
  }

  playSource(String? url) async {
    await player.play(UrlSource(url!));
  }

  pause() async {
    await player.pause();
  }

  triggerPlayBtn() {
    isPlaying.value = !isPlaying.value;
    update();
  }

  triggerSource(String? url) async {
    if (isPlaying.value) {
      await pause();
    } else {
      await playSource(url);
    }
  }

  getLikeStatus(DanModel dan) {
    String myId = userController.curentUserModel.id!;

    if (dan.likers!.contains(myId)) {
      return true;
    } else {
      return false;
    }
  }

  getPlayBtnStatus() => isPlaying.value;

  isItMyPost(String userId) {
    return userId == userController.curentUserModel.id;
  }
}
