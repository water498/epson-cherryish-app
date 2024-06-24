import 'package:flutter/material.dart';
import 'package:seeya/view/screens.dart';

import '../../constants/app_colors.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  int _currentIndex = 0;

  final Map<int, Widget> tabPages = {
    0: HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(3, (index) => tabPages[index] ?? Container()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontSize: 8,),
        unselectedLabelStyle: const TextStyle(fontSize: 8,),
        selectedItemColor: AppColors.main700,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 0,
        backgroundColor: AppColors.grey500,
        currentIndex: _currentIndex,
        onTap: (value) {
          onTabTapped(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_library_outlined),
              activeIcon: Icon(Icons.photo_library),
              label: '리스트'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag_faces),
            activeIcon: Icon(Icons.tag_faces_rounded),
            label: '내정보'
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {

    if (!tabPages.containsKey(index)) {
      switch (index) {
        case 1:
          tabPages[index] = PhotoListScreen();
          break;
        case 2:
          tabPages[index] = MyPageScreen();
          break;
      }
    }

    setState(() {
      _currentIndex = index;
    });
  }

}


