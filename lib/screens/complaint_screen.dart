import 'package:flutter/material.dart';
import 'package:office_user/providers/complaint_provider.dart';
import 'package:provider/provider.dart';

import '../providers/contract_provider.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  int roomId = 0;

  @override
  void initState() {
    super.initState();

    final contractProvider =
        Provider.of<ContractProvider>(context, listen: false);
    contractProvider.fetchContractList();
    final complaintProvider =
        Provider.of<ComplaintProvider>(context, listen: false);
    complaintProvider.fetchComplaints();
    if (contractProvider.contractList.contractList.isNotEmpty) {
      final currentRoomId =
          contractProvider.contractList.contractList.last.room.id;
      roomId = currentRoomId;
    }
  }

  final TextEditingController _textEditingController = TextEditingController();

  Future<void> _registerComplaint(int roomId, String complaintMessage) async {
    await Provider.of<ComplaintProvider>(context, listen: false)
        .registerComplaint(roomId, complaintMessage);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void registerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('민원 등록'),
              content: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(hintText: '민원 내용을 입력하세요'),
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
                    _registerComplaint(roomId, _textEditingController.text);
                  },
                  child: const Text('등록'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ComplaintProvider>(
        builder: (context, complaintProvider, child) {
          if (complaintProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return complaintProvider.complaintList.isEmpty
              ? const Center(
                  child: Text('민원 내역이 없습니다'),
                )
              : ListView.builder(
                  itemCount: complaintProvider.complaintList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 4, top: 4),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  overflow: TextOverflow.ellipsis,
                                  complaintProvider
                                      .complaintList[index].complaintMessage,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize,
                                      fontWeight: FontWeight.w600)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(complaintProvider.complaintList[index]
                                      .statusToString()),
                                  Text(complaintProvider
                                      .complaintList[index].updatedAt
                                      .toString()
                                      .split(" ")[0])
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          roomId == 0
              ? ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('진행중인 계약이 없습니다'),
                  ),
                )
              : registerDialog();
        },
        icon: const Icon(Icons.app_registration_outlined),
        isExtended: false,
        label: const Text(''),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}
