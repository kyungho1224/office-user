import 'package:flutter/material.dart';
import 'package:office_user/services/api_service.dart';
import '../models/score_model.dart';

class ScoreProvider with ChangeNotifier {
  List<Score> _scoreList = [];
  bool _isLoading = false;

  List<Score> get scoreList => _scoreList;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  Future<List<Score>> fetchScores() async {
    setLoading(true);
    _scoreList = await ApiService.getScoreList();
    setLoading(false);
    notifyListeners();
    return _scoreList;
  }

  Future<void> submitScore(int id, int score, String comment) async {
    setLoading(true);
    bool result = await ApiService.sendScore(id, score, comment);
    if (result) {
      Score updatedScore = _scoreList.firstWhere((score) => score.id == id);
      updatedScore.updateScore(score, comment);
    }
    setLoading(false);
    notifyListeners();
  }

}
