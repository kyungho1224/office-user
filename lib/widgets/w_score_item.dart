import 'package:flutter/material.dart';
import 'package:office_user/models/score_model.dart';

class ScoreItem extends StatelessWidget {
  final Score score;

  ScoreItem({required this.score, super.key});

  @override
  Widget build(BuildContext context) {
    String year = score.createdAt.toString().split(" ")[0].split("-")[0];
    String month = score.createdAt.toString().split(" ")[0].split("-")[1];
    return Card(
      child: ListTile(
        leading: FlutterLogo(),
        title:
            Text("$year년 $month월 ${score.typeToString(score.ratingType)} 평가"),
      ),
    );
  }
}
