import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostController extends GetxController {
  RxBool isPlaying = false.obs;
  final player = AudioPlayer();
  final prefs = Get.find<SharedPreferences>();
  final CollectionReference buySellRef =
      FirebaseFirestore.instance.collection('posts');

  RxList<String> favorites = <String>[].obs;
  RxList<String> orders = <String>[].obs;

  final String _favoritesKey = 'cart';
  final String _ordersKey = 'order';

  final userController = Get.find<UserController>();
  RxBool isLiked = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

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

  ///cart

  void addRemoveCartItem(String? documentId) {
    if (!favorites.contains(documentId)) {
      favorites.add(documentId!);
      customSnackbar("Post added to cart", "");
    } else {
      favorites.remove(documentId);
      customSnackbar("Post removed from cart", "");
    }
    saveCartTiems();
    update();
  }

  void addRemoveOrderItem(String? documentId) {
    if (!orders.contains(documentId)) {
      orders.add(documentId!);
      customSnackbar("Post added to Orders", "");
    } else {
      orders.remove(documentId);
      customSnackbar("Post removed from Orders", "");
    }
    saveCartTiems();
    update();
  }

  isAddedToCart(String item) => favorites.contains(item);

  Future<void> saveCartTiems() async {
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }

  Future<void> saveOrderItems() async {
    await prefs.setStringList(_ordersKey, orders.toList());
  }

  Future<void> loadCart() async {
    final savedFavorites = prefs.getStringList(_favoritesKey);
    if (savedFavorites != null) {
      favorites.addAll(savedFavorites);
    }
  }

  Future<void> loadOrders() async {
    final orders = prefs.getStringList(_ordersKey);
    if (orders != null) {
      favorites.addAll(orders);
    }
  }

  Stream<List<DanModel>> fetchCartItems() {
    return buySellRef.snapshots().map((snapshot) {
      return snapshot.docs
          .where((e) => favorites.contains(e['docid']))
          .map((doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        return DanModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<DanModel>> fetchOrdersItems() {
    return buySellRef.snapshots().map((snapshot) {
      return snapshot.docs.where((e) => orders.contains(e['docid'])).map((doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        return DanModel.fromJson(data);
      }).toList();
    });
  }
}
