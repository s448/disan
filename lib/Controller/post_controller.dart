import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/Model/notification_model.dart';
import 'package:disan/Model/order_model.dart';
import 'package:disan/Service/fcm_services.dart';
import 'package:disan/Service/firebase_services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  RxBool isPlaying = false.obs;
  final player = AudioPlayer();
  final prefs = Get.find<SharedPreferences>();
  final CollectionReference postRef =
      FirebaseFirestore.instance.collection('posts');
  final FcmServices _fcm = FcmServices();
  final FirebaseServices _firebaseServices = FirebaseServices();
  RxList<String> cart = <String>[].obs;
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
    if (!cart.contains(documentId)) {
      cart.add(documentId!);
      customSnackbar("Post added to cart", "");
    } else {
      cart.remove(documentId);
      customSnackbar("Post removed from cart", "");
    }
    saveCartTiems();
    update();
  }

  notifyMerchant(DanModel dan) async {
    String docid = const Uuid().v1();
    String title = "New order".tr;
    String body = "${dan.user!.name} orderd your product".tr;
    //send a notification to the publisher
    await _fcm.sendNotification(dan.user!.token!, title, body);
    OrderModel order = OrderModel(
      id: docid,
      dan: dan,
      date: Timestamp.now(),
      topic: "order",
      user: userController.curentUserModel,
    );
    //save the notification on firestore
    await _firebaseServices.saveOrderToFirebase(order);
  }

  backToCart(String? documentId) {
    orders.remove(documentId);
    cart.add(documentId!);
    saveCartTiems();
    saveOrderItems();
    update();
  }

  void addRemoveOrderItem(DanModel dan) async {
    var documentId = dan.id;
    if (!orders.contains(documentId)) {
      await notifyMerchant(dan);
      orders.add(documentId!);
      cart.remove(documentId);
      customSnackbar("Post added to Orders".tr, "");
    } else {
      cart.add(documentId!);
      orders.remove(documentId);
      customSnackbar("Post removed from Orders".tr, "");
    }
    saveCartTiems();
    saveOrderItems();
    update();
  }

  isAddedToCart(String item) => cart.contains(item);

  Future<void> saveCartTiems() async {
    await prefs.setStringList(_favoritesKey, cart.toList());
  }

  Future<void> saveOrderItems() async {
    await prefs.setStringList(_ordersKey, orders.toList());
  }

  Future<void> loadCart() async {
    final savedFavorites = prefs.getStringList(_favoritesKey);
    if (savedFavorites != null) {
      cart.addAll(savedFavorites);
    }
  }

  Future<void> loadOrders() async {
    final orders = prefs.getStringList(_ordersKey);
    if (orders != null) {
      cart.addAll(orders);
    }
  }

  Stream<List<DanModel>> fetchCartItems() {
    return postRef.snapshots().map((snapshot) {
      return snapshot.docs.where((e) => cart.contains(e['id'])).map((doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        return DanModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<DanModel>> fetchOrdersItems() {
    return postRef.snapshots().map((snapshot) {
      return snapshot.docs.where((e) => orders.contains(e['id'])).map((doc) {
        Map<String, dynamic> data = (doc.data() as Map<String, dynamic>);
        return DanModel.fromJson(data);
      }).toList();
    });
  }
}
