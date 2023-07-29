
import 'package:asgn/Screen/Home.dart';
import 'package:asgn/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Auth/Account.dart';
import 'Map.dart';
import 'Recentlyview/recentlyview.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[


    Home(),
    MapCategories(),
    RecentlyViewdata(),
     Accounts()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Bookmark',
                backgroundColor: Colors.white),

            BottomNavigationBarItem(
                icon: Icon(Icons.account_box_sharp),
                label: 'Me',
                backgroundColor: Colors.white),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black,
          selectedItemColor: Mytheme().primary,
          iconSize: 25,
          onTap: _onItemTapped,
          elevation: 0),
    );
  }
}