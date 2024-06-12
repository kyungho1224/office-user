import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:office_user/services/api_service.dart';

import '../models/alarm_model.dart';
import '../network/retrofit_service.dart';

class AlarmProvider with ChangeNotifier {

  AlarmProvider() {
    fetchAlarms();
    hasUnreadAlarm();
  }

  static const storage = FlutterSecureStorage();
  final RetrofitService _retrofitService = RetrofitService(Dio());

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
    final token = await storage.read(key: 'token');
    setLoading(true);
    _alarmList = await _retrofitService.getAlarmList('Bearer $token');
    setLoading(false);
    notifyListeners();
    return _alarmList;
  }

  Future<int> readAlarm(int id) async {
    final token = await storage.read(key: 'token');
    setLoading(true);
    int readId = await _retrofitService.readAlarm('Bearer $token', id);

    // Alarm readAlarm = _alarmList.firstWhere((alarm) => alarm.id == id);
    // readAlarm.read();
    fetchAlarms();
    setLoading(false);
    // notifyListeners();
    hasUnreadAlarm();
    return readId;
  }

  Future<bool> hasUnreadAlarm() async {
    final token = await storage.read(key: 'token');
    setLoading(true);
    _hasNewAlarm = await _retrofitService.hasNewAlarm('Bearer $token');
    setLoading(false);
    notifyListeners();
    return _hasNewAlarm;
  }
}