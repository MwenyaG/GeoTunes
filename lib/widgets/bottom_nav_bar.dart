import 'package:flutter/material.dart';
import 'package:finalassignment/data/app_states.dart';
import 'package:provider/provider.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appStates = Provider.of<AppStates>(context);

    return BottomNavigationBar(
      currentIndex: appStates.bottomNavBarIndex,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
              color: Colors.brown
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
              color: Colors.pinkAccent
          ),

          label: 'Favorites',


        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.location_on_outlined,
              color: Colors.blueAccent,
          ),
          label: 'Nearby',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(
        //     Icons.settings_rounded,
        //   ),
        //   label: 'Settings',
        // ),
      ],
      onTap: (index) {
        if (appStates.bottomNavBarIndex == index) return;
        appStates.setBottomNavBarIndex(index);
        appStates.selectedClear();
      },
      type: BottomNavigationBarType.fixed,
      unselectedFontSize: 14.0,
    );
  }
}
