import 'package:flutter/material.dart';
import 'package:office_user/providers/alarm_provider.dart';
import 'package:office_user/providers/complaint_provider.dart';
import 'package:office_user/providers/contract_provider.dart';
import 'package:office_user/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../providers/score_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ScoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ContractProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AlarmProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ComplaintProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: LoginScreen(),
      ),
    ),
  );
}
