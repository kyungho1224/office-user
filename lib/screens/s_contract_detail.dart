import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_user/models/contract_model.dart';
import 'package:office_user/providers/contract_provider.dart';
import 'package:provider/provider.dart';

class ContractDetailScreen extends StatelessWidget {
  const ContractDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String formatCurrency(int amount) {
      final NumberFormat formatter = NumberFormat('#,##0');
      return formatter.format(amount);
    }

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
              '전체 계약 목록',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
                  return ListView.builder(
                    itemCount:
                        contractProvider.contractList.contractList.length,
                    itemBuilder: (context, index) {
                      Contract contract =
                          contractProvider.contractList.contractList[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('장소 : ${contract.room.building.name} '
                                  '/ ${contract.room.name} '
                                  '/ ${contract.room.floor}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '기간 : ${contract.startDate.toString().split(" ")[0]} '
                                  '~ ${contract.endDate.toString().split(" ")[0]}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '보증금 / 임대료 : ${formatCurrency(contract.deposit)} '
                                  '/ ${formatCurrency(contract.rentalPrice)}'),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                  '상태 : ${contract.statusToString(contract.contractStatus)}')
                            ],
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
