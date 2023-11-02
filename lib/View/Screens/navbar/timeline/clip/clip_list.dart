// import 'package:disan/Controller/clip_controller.dart';
// import 'package:disan/Model/clip_model.dart';
// import 'package:disan/Model/story_model.dart';
// import 'package:disan/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ClipBar extends StatelessWidget {
//   ClipBar({super.key});
//   final controller = Get.put(ClipController(), permanent: true);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SizedBox(
//         height: 70,
//         width: Get.width,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: () => controller.pickClipMedia(),
//                     child: CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.blue,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.add_a_photo_sharp,
//                             color: Colors.white,
//                           ),
//                           Text(
//                             "Create".tr,
//                             style: const TextStyle(color: Colors.white),
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             FutureBuilder(
//                 future: controller.getClips(),
//                 builder: (context, snapshot) {
//                   List<ClipModel> clips = snapshot.data ?? [];
//                   print(clips);
//                   return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: clips.length,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         ClipModel clip = clips[index];

//                         return InkWell(
//                           onTap: () => Navigator.pushNamedAndRemoveUntil(context, newRouteName, (route) => false)
//                               Get.toNamed(Routes.viewStory, arguments: {
//                             'stories': clip,
//                           }),
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: CircleAvatar(
//                               radius: 29,
//                               backgroundColor: Colors.blue,
//                               backgroundImage: NetworkImage(
//                                 stories[0].img.toString(),
//                               ),
//                             ),
//                           ),
//                         );
//                       });
//                 })
//           ],
//         ),
//       ),
//     );
//   }
// }
