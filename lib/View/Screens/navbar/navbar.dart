import 'package:disan/View/Screens/navbar/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
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
              icon: const Icon(Icons.notifications),
              label: 'Notifications'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.gamecontroller_fill),
              label: 'Games'.tr,
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
  // const NotificationsPage(),
  // const ProfilePage(),
  const HomePage(),
  const HomePage(),
  const HomePage(),
  const HomePage(),
  // const FavoritesPage(),
  // const SettingsPage(),
];
