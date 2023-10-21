import 'package:disan/routes.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Title of 1st Page',
            body: 'Body of 1st Page',
            image: buildImage("images/image_1.png"),
            //getPageDecoration, a method to customise the page style
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Title of 2nd Page',
            body: 'Body of 2nd Page',
            image: buildImage("images/image_2.png"),
            //getPageDecoration, a method to customise the page style
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'Title of 3rd Page',
            body: 'Body of 3rd Page',
            image: buildImage("images/image_3.png"),
            //getPageDecoration, a method to customise the page style
            decoration: getPageDecoration(),
          ),
        ],
        onDone: () {
          Get.offAllNamed(Routes.login);
        },
        scrollPhysics: const ClampingScrollPhysics(),
        showDoneButton: true,
        showNextButton: true,
        showSkipButton: true,
        skip: Text("Skip".tr,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.arrow_forward_ios_outlined),
        done: Text("Done".tr,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: getDotsDecorator(),
      ),
    );
  }

  //widget to add the image on screen
  Widget buildImage(String imagePath) {
    return Center(
        child: Image.asset(
      imagePath,
      width: 450,
      height: 200,
    ));
  }

  //method to customise the page style
  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 120),
      pageColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  //method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Colors.indigo,
      color: Colors.grey,
      activeSize: Size(12, 5),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}
