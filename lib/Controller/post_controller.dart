import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  RxBool isPlaying = false.obs;
  final player = AudioPlayer();

  // final userController = Get.find<UserController>();
  RxBool isLiked = false.obs;

  triggerLike() {
    isLiked.value = !isLiked.value;
    update();
  }

  playSource(String? url) async {
    await player.play(UrlSource(url!));
  }

  triggerPlayBtn() {
    isPlaying.value = !isPlaying.value;
    update();
  }

  getLikeStatus() => isLiked.value;
  getPlayBtnStatus() => isPlaying.value;
}
