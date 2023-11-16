import 'package:disan/Controller/user_controller.dart';
import 'package:disan/Service/fcm_services.dart';
import 'package:disan/View/Screens/navbar/chat/register_chat.dart';
import 'package:disan/View/Screens/navbar/home_page.dart';
import 'package:disan/View/Screens/navbar/notifications/notifications_page.dart';
import 'package:disan/View/Screens/navbar/clip/clip_page_timeline.dart';
import 'package:disan/View/Screens/user/current_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  @override
  void initState() {
    Get.put(UserController(), permanent: true).initUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FcmServices().initNotification();
    });
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: _selectedIndex == 1
              ? Colors.green
              : _selectedIndex == 2
                  ? Colors.pink
                  : _selectedIndex == 3
                      ? Colors.red
                      : Colors.blue,
          selectedLabelStyle: TextStyle(
            color: _selectedIndex == 1
                ? Colors.green
                : _selectedIndex == 2
                    ? Colors.pink
                    : _selectedIndex == 3
                        ? Colors.red
                        : Colors.blue,
          ),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.chat),
              label: 'Chat'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.videocam_rounded),
              label: 'Clips'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: 'Notifies'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: 'My Profile'.tr,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class NavBarItemIcon extends StatelessWidget {
  const NavBarItemIcon({
    super.key,
    required this.imgPath,
  });
  final String imgPath;
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imgPath,
      width: 25,
      height: 25,
    );
  }
}

var pages = <Widget>[
  HomePage(),
  const ChatRegister(),
  ClipTimeline(),
  NotificationsPage(),
  CurrentUserProfile(),
];
