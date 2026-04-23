import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';
import 'package:track/presentaion/screen/book.dart';
import 'package:track/presentaion/screen/fav_screen.dart';
import 'package:track/presentaion/screen/favorite_screen.dart';
import 'package:track/presentaion/screen/home_screen.dart';
import 'package:track/presentaion/screen/settinh_screen.dart';

class AppBottomBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomBar({super.key, required this.currentIndex});

  void _goToPage(BuildContext context, int index) {
    Widget page;

    switch (index) {
      case 0:
        page = HomeScreen();
        break;
      case 1:
        page = BookScreen();
        break;
      case 2:
        page = FavoriteScreen(id: '', idS: '');
        break;
      case 3:
        page = const SettingScreen();
        break;
      default:
        page = const HomeScreen();
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
      child: NavigationBar(
        height: 72,
        backgroundColor: ColorManager.prymaryColor,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          _goToPage(context, index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.flight_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.flight, color: Colors.white),
            label: 'Book',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            selectedIcon: Icon(Icons.favorite, color: Colors.white),
            label: 'Favorite',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Colors.white),
            selectedIcon: Icon(Icons.settings, color: Colors.white),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
