import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:office_user/models/tenant_model.dart';
import 'package:office_user/network/retrofit_service.dart';

class TenantProvider with ChangeNotifier {
  TenantProvider() {
    _fetchTenants();
  }

  final RetrofitService _retrofitService = RetrofitService(Dio());

  TenantList _tenantList = TenantList(count: 0, tenantList: []);
  bool _isLoading = false;

  TenantList get tenantList => _tenantList;

  bool get isLoading => _isLoading;

  Future<void> _fetchTenants() async {
    _isLoading = true;
    notifyListeners();

    _tenantList = await _retrofitService.getTenantList();

    _isLoading = false;
    notifyListeners();
  }
}
