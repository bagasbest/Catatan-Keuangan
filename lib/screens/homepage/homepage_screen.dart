import 'package:flutter/material.dart';

import 'chart_screen.dart';
import 'note_screen.dart';
import 'option_screen.dart';

class HomepageScreen extends StatefulWidget {
  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  int _currentIndex = 0;

  final tabs = [
    ChartScreen(),
    NoteScreen(),
    OptionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xff383838),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          left: 16,
          right: 16,
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BottomNavigationBar(
              backgroundColor: Colors.orange,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Colors.black54,
                  ),
                  label: "Beranda",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.article,
                    color: Colors.black54,
                  ),
                  label: "Catatan",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.black54,
                  ),
                  label: "Pengaturan",
                ),
              ],
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              selectedItemColor: Colors.black,
              selectedFontSize: 18,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
        ),
      ),
      body: tabs[_currentIndex],
    );
  }
}
