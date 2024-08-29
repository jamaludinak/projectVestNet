import 'package:flutter/material.dart';
import '../component/home/HomeFragment.dart';
import '../component/home/NotificationFragment.dart';
import '../component/profile/ProfileFregment.dart';
import '../screen/SearchScreen.dart';
import '../utils/Colors.dart';
import 'PortofolioScreen.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {

  int currentIndex = 0;
  List<Widget> tabs = [
    HomeFragment(),
    SearchScreen(),
    NotificationFragment(),
    PortofolioScreen(),
    ProfileFragment(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(children: tabs, index: currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: PrimaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Pencarian',
            activeIcon: Icon(Icons.search_rounded),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            label: 'Notifikasi',
            activeIcon: Icon(Icons.notifications_sharp),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Portofolio',
            activeIcon: Icon(Icons.account_balance_wallet),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Akun',
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
