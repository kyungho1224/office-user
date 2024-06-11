import 'dart:async';

import 'package:flutter/material.dart';
import 'package:office_user/models/score_model.dart';
import 'package:office_user/providers/contract_provider.dart';
import 'package:office_user/providers/score_provider.dart';
import 'package:office_user/screens/s_contract_detail.dart';
import 'package:office_user/screens/s_score_detail.dart';
import 'package:office_user/services/api_service.dart';
import 'package:office_user/widgets/w_score_item.dart';
import 'package:provider/provider.dart';

import '../models/auth_member_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<AuthMember> authMember = ApiService.getMemberInfo();
  Future<List<AuthMember>> memberList = ApiService.getMemberList();

  @override
  void initState() {
    super.initState();
    final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
    scoreProvider.fetchScores();
    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    contractProvider.fetchContractList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final evaluationList = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "평가 예정 목록",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScoreDetailScreen(),
                    ),
                  );
                },
                child: const Text("전체보기"),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 12,
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<ScoreProvider>(
            builder: (context, scoreProvider, child) {
              if (scoreProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<Score> incompleteList = scoreProvider.scoreList
                  .where((score) => !score.isCompleted())
                  .toList();
              return incompleteList.isEmpty
                  ? const Card(
                      child: Center(
                        child: Text('진행할 평가 항목이 없습니다.'),
                      ),
                    )
                  : ListView.builder(
                      itemCount: incompleteList.length,
                      itemBuilder: (context, index) {
                        return ScoreItem(score: incompleteList[index]);
                      },
                    );
            },
          ),
        ),
      ],
    );

    final contractInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "계약 정보",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // fullscreenDialog: true,
                        builder: (context) => const ContractDetailScreen(),
                      ));
                },
                child: const Text("전체보기"),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 12,
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer<ContractProvider>(
            builder: (context, contractProvider, child) {
              if (contractProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return contractProvider.contractList.contractList.isEmpty
                  ? const Card(
                      child: Center(
                        child: Text('진행중인 계약이 없습니다.'),
                      ),
                    )
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.check_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    "${contractProvider.contractList.contractList.last.room.building.name} "
                                    "/ ${contractProvider.contractList.contractList.last.room.name} "
                                    "/ ${contractProvider.contractList.contractList.last.room.floor}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.check_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    "${contractProvider.contractList.contractList.last.startDate.toString().split(" ")[0]} "
                                    "~ ${contractProvider.contractList.contractList.last.endDate.toString().split(" ")[0]}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ),
      ],
    );

    final membersInfo = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text(
            "우리 멤버들",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: memberList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PageView.builder(
                  controller: PageController(
                    initialPage: 0,
                    viewportFraction: 0.95,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.email_outlined),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(snapshot.data![index].email)
                              ],
                            ),
                            Row(children: [
                              const Icon(Icons.phone_android_outlined),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(snapshot.data![index].phone)
                            ])
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    );

    final userInfo = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text(
            "내 정보",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
            child: FutureBuilder(
          future: authMember,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(snapshot.data!.email),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone_android_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(snapshot.data!.phone)
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.apartment_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(snapshot.data!.tenant.name)
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        )),
      ],
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: userInfo,
            ),
            Flexible(
              flex: 2,
              child: membersInfo,
            ),
            Flexible(
              flex: 2,
              child: contractInfo,
            ),
            Flexible(
              flex: 4,
              child: evaluationList,
            ),
          ],
        ),
      ),
    );
  }
}
