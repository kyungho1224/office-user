import 'package:flutter/material.dart';
import 'package:office_user/screens/nav_body.dart';
import 'package:office_user/screens/s_alarm_detail.dart';
import 'package:provider/provider.dart';

import '../providers/alarm_provider.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> with WidgetsBindingObserver {
  late int index;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    index = 0;
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    alarmProvider.fetchAlarms();
    alarmProvider.hasUnreadAlarm();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
        alarmProvider.hasUnreadAlarm();
        print('resume');
        break;
      case AppLifecycleState.detached:
        print('detached');
        break;
      case AppLifecycleState.inactive:
        print('inactive');
        break;
      case AppLifecycleState.hidden:
        print('hidden');
        break;
      case AppLifecycleState.paused:
        print('paused');
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        title: const Text(
          'Office for User',
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          Consumer<AlarmProvider>(
            builder: (context, alarmProvider, child) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    // _hasNew = !_hasNew;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AlarmDetailScreen(),
                      ),
                    );
                  });
                },
                icon: Icon(
                  alarmProvider.hasNewAlarm
                      ? Icons.notifications_active
                      : Icons.notifications,
                  color: alarmProvider.hasNewAlarm
                      ? Colors.blue
                      : Colors.blue.shade200,
                ),
              );
            },
          ),
        ],
      ),
      body: NavBody(
        index: index,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (newIndex) => {
          setState(() {
            index = newIndex;
            final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
            alarmProvider.hasUnreadAlarm();
          })
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'Search',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement_outlined),
            label: 'Complaint',
          ),
        ],
      ),
    );
  }
}
