import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:office_user/providers/score_provider.dart';
import 'package:provider/provider.dart';

import '../models/score_model.dart';

class ScoreDetailScreen extends StatefulWidget {
  const ScoreDetailScreen({super.key});

  @override
  State<ScoreDetailScreen> createState() => _ScoreDetailScreenState();
}

class _ScoreDetailScreenState extends State<ScoreDetailScreen> {
  int _selectedScore = 50;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitScoreAndComment(int id, int score, String comment) async {
    await Provider.of<ScoreProvider>(context, listen: false)
        .submitScore(id, score, comment);
    if (!mounted) return;
    await Provider.of<ScoreProvider>(context, listen: false).fetchScores();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _incompleteDialog(Score score) {
    showDialog(
      context: context,
      builder: (context) {
        String year = score.createdAt.toString().split(" ")[0].split("-")[0];
        String month = score.createdAt.toString().split(" ")[0].split("-")[1];
        String title =
            "$year년 $month월 ${score.typeToString(score.ratingType)} 평가";
        int dialogSelectedScore = _selectedScore;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('점수를 선택하세요'),
                  SizedBox(
                    height: 100,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (value) {
                        setDialogState(() {
                          dialogSelectedScore = value;
                        });
                      },
                      children: List.generate(
                        101,
                        (index) => Center(
                          child: Text(index.toString()),
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(hintText: '코멘트를 입력하세요'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    int id = score.id;
                    String comment = _textEditingController.text;
                    _submitScoreAndComment(id, dialogSelectedScore, comment);
                  },
                  child: const Text('전송'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _completedDialog(Score score) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${score.score}점"),
          content: Text(score.comment),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "전체 평가 목록",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Consumer<ScoreProvider>(
                builder: (context, scoreProvider, child) {
                  if (scoreProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: scoreProvider.scoreList.length,
                    itemBuilder: (context, index) {
                      String year = scoreProvider.scoreList[index].createdAt
                          .toString()
                          .split(" ")[0]
                          .split("-")[0];
                      String month = scoreProvider.scoreList[index].createdAt
                          .toString()
                          .split(" ")[0]
                          .split("-")[1];
                      String title =
                          "$year년 $month월 ${scoreProvider.scoreList[index].typeToString(scoreProvider.scoreList[index].ratingType)} 평가";
                      return GestureDetector(
                        onTap: () => {
                          scoreProvider.scoreList[index].isCompleted()
                              ? _completedDialog(scoreProvider.scoreList[index])
                              : _incompleteDialog(
                                  scoreProvider.scoreList[index])
                        },
                        child: Card(
                          child: ListTile(
                            leading: const FlutterLogo(),
                            title: Text(title),
                            subtitle:
                                scoreProvider.scoreList[index].isCompleted()
                                    ? const Text("평가 완료")
                                    : const Text("평가 대기"),
                            trailing: Icon(
                              scoreProvider.scoreList[index].isCompleted()
                                  ? Icons.lock_outlined
                                  : Icons.lock_open_outlined,
                              color:
                                  scoreProvider.scoreList[index].isCompleted()
                                      ? Colors.red
                                      : Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
