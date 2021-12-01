// ignore_for_file: prefer_const_constructors

import 'package:ebookapp/view.bottom_view/bottom_favorite.dart';
import 'package:ebookapp/view.bottom_view/bottom_library.dart';
import 'package:ebookapp/view.bottom_view/bottom_profile.dart';
import 'package:ebookapp/view.bottom_view/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomView extends StatefulWidget {
  @override
  _BottomViewState createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> {
  int currentIndex = 0;
  List<Widget> body = [
    Home(),
    BottomFavorite(),
    BottomLibrary(),
    BottomProfile()
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTapBottomView,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books), label: 'Library'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border), label: 'Favorite'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          ],
        ),
        body: body[currentIndex],
      ),
    );
  }

  void onTapBottomView(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
