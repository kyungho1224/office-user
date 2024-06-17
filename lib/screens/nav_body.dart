import 'package:flutter/material.dart';
import 'package:office_user/screens/home_screen.dart';
import 'package:office_user/screens/complaint_screen.dart';
import 'package:office_user/screens/search_screen.dart';

class NavBody extends StatelessWidget {
  final int index;

  const NavBody({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return HomeScreen();
    }
    // else if (index == 1) {
    //   return const SearchScreen();
    // }
    return const ComplaintScreen();
  }
}
