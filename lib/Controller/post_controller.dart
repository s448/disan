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

  getLikeStatus() => isLiked.value;
  getPlayBtnStatus() => isPlaying.value;
}
