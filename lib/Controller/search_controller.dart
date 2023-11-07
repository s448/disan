import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchPageController extends GetxController {
  final searchQuery = ''.obs;

  Stream<QuerySnapshot<Map<String, dynamic>>> get searchResults =>
      FirebaseFirestore.instance
          .collection('posts')
          .where('description', isGreaterThanOrEqualTo: searchQuery.value)
          .snapshots();

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
