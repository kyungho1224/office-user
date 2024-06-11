import 'package:flutter/material.dart';
import 'package:office_user/services/api_service.dart';

import '../models/alarm_model.dart';

class AlarmProvider with ChangeNotifier {
  List<Alarm> _alarmList = [];
  bool _isLoading = false;
  bool _hasNewAlarm = false;

  List<Alarm> get alarmList => _alarmList;
  bool get isLoading => _isLoading;
  bool get hasNewAlarm => _hasNewAlarm;

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  Future<List<Alarm>> fetchAlarms() async {
    setLoading(true);
    _alarmList = await ApiService.getAlarmList();
    setLoading(false);
    notifyListeners();
    return _alarmList;
  }

  Future<void> readAlarm(int id) async {
    setLoading(true);
    bool result = await ApiService.readAlarm(id);
    if (result) {
      Alarm readAlarm = _alarmList.firstWhere((alarm) => alarm.id == id);
      readAlarm.read();
    }
    setLoading(false);
    notifyListeners();
  }

  Future<bool> hasUnreadAlarm() async {
    setLoading(true);
    _hasNewAlarm = await ApiService.hasNewAlarm();
    setLoading(false);
    notifyListeners();
    return _hasNewAlarm;
  }
}