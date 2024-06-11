import 'package:flutter/material.dart';
import 'package:office_user/providers/alarm_provider.dart';
import 'package:provider/provider.dart';

class AlarmDetailScreen extends StatefulWidget {
  const AlarmDetailScreen({super.key});

  @override
  State<AlarmDetailScreen> createState() => _AlarmDetailScreenState();
}

class _AlarmDetailScreenState extends State<AlarmDetailScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AlarmProvider>(context, listen: false).fetchAlarms();
  }

  Future<void> _readAlarm(int id) async {
    await Provider.of<AlarmProvider>(context, listen: false).readAlarm(id);
    if (!mounted) return;
    await Provider.of<AlarmProvider>(context, listen: false).fetchAlarms();
    if (!mounted) return;
    await Provider.of<AlarmProvider>(context, listen: false).hasUnreadAlarm();
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
      ),
      body: Consumer<AlarmProvider>(
        builder: (context, alarmProvider, child) {
          return alarmProvider.alarmList.isEmpty
              ? const Center(
                  child: Text('알림이 없습니다'),
                )
              : ListView.builder(
                  itemCount: alarmProvider.alarmList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 4, top: 4),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    alarmProvider.alarmList[index].alarmTitle),
                                content: SingleChildScrollView(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Text(
                                          alarmProvider
                                              .alarmList[index].alarmMessage,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(alarmProvider.alarmList[index]
                                            .typeToString()),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(alarmProvider
                                            .alarmList[index].createdAt
                                            .toString())
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("닫기"),
                                  )
                                ],
                              );
                            },
                          );
                          _readAlarm(alarmProvider.alarmList[index].id);
                        },
                        child: Card(
                          elevation: 3,
                          color: alarmProvider.alarmList[index].readStatus
                              ? Colors.grey.shade300
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  alarmProvider.alarmList[index].alarmTitle,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  alarmProvider.alarmList[index].alarmMessage,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .fontSize,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
