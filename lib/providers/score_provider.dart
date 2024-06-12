import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:office_user/network/retrofit_service.dart';

import '../models/score_model.dart';

class ScoreProvider with ChangeNotifier {
  ScoreProvider() {
    fetchScores();
  }

  static const storage = FlutterSecureStorage();
  final RetrofitService _retrofitService = RetrofitService(Dio());

  List<Score> _scoreList = [];
  bool _isLoading = false;

  List<Score> get scoreList => _scoreList;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  Future<List<Score>> fetchScores() async {
    final token = await storage.read(key: 'token');
    setLoading(true);
    _scoreList = await _retrofitService.getScoreList('Bearer $token');
    setLoading(false);
    notifyListeners();
    print("score provider fetch scores");
    return _scoreList;
  }

  Future<void> submitScore(int id, int score, String comment) async {
    final token = await storage.read(key: 'token');
    final body = <String, dynamic>{'score': score, 'comment': comment};
    setLoading(true);
    final result = await _retrofitService.updateScore(
      'Bearer $token',
      id,
      body,
    );
    if (result.id == id) {
      Score updatedScore = _scoreList.firstWhere((score) => score.id == id);
      updatedScore.updateScore(score, comment);
    }
    setLoading(false);
    notifyListeners();
  }
}
