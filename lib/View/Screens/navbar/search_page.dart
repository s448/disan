import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disan/Controller/search_controller.dart';
import 'package:disan/Model/dan_model.dart';
import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  final searchController = Get.put(SearchPageController());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: const TextStyle(color: Colors.white),
          onChanged: (value) => searchController.updateSearchQuery(value),
          decoration: InputDecoration(
            hintText: 'Search...'.tr,
            hintStyle: const TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: searchController.searchResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error retrieving data'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No data found'.tr),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final document = snapshot.data!.docs[index];
                  // Customize how you display the data from the Firestore document
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => Get.toNamed(Routes.productDetails,
                            arguments: {
                              'dan': DanModel.fromJson(document.data())
                            }),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(document['user.profile']),
                          ),
                          title: Text(document['user.name']),
                          subtitle: Text(document['description']),
                        ),
                      ),
                      Divider()
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
