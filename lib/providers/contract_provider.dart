import 'package:flutter/material.dart';
import 'package:office_user/models/contract_model.dart';
import 'package:office_user/services/api_service.dart';

class ContractProvider with ChangeNotifier {

  bool _isLoading = false;
  ContractList _contractList = ContractList(count: 0, contractList: []);

  ContractList get contractList => _contractList;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  Future<ContractList> fetchContractList() async {
    setLoading(true);
    _contractList = await ApiService.getContractList();
    notifyListeners();
    setLoading(false);
    return _contractList;
  }

}