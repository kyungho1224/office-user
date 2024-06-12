import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:office_user/models/contract_model.dart';

import '../network/retrofit_service.dart';

class ContractProvider with ChangeNotifier {
  static const storage = FlutterSecureStorage();
  final RetrofitService _retrofitService = RetrofitService(Dio());

  ContractList _contractList = ContractList(count: 0, contractList: []);
  bool _isLoading = false;

  ContractList get contractList => _contractList;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  Future<ContractList> fetchContractList() async {
    final token = await storage.read(key: 'token');
    setLoading(true);
    _contractList = await _retrofitService.getContractList(
      'Bearer $token',
    );
    notifyListeners();
    setLoading(false);
    return _contractList;
  }
}
