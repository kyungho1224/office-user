import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:office_user/models/auth_member_model.dart';

import '../network/retrofit_service.dart';

class AuthMemberProvider with ChangeNotifier {
  AuthMemberProvider() {
    fetchMember();
    fetchMemberList();
  }

  static const storage = FlutterSecureStorage();
  final RetrofitService _retrofitService = RetrofitService(Dio());

  AuthMember _authMember =
      AuthMember(email: "", id: 0, phone: "", tenant: null);
  bool _isLoading = false;
  List<AuthMember> _memberList = [];

  AuthMember get authMember => _authMember;
  bool get isLoading => _isLoading;
  List<AuthMember> get memberList => _memberList;

  Future<AuthMember> fetchMember() async {
    final token = await storage.read(key: 'token');
    _isLoading = true;
    notifyListeners();
    _authMember = await _retrofitService.getMemberInfo('Bearer $token');
    _isLoading = false;
    notifyListeners();
    return _authMember;
  }

  Future<List<AuthMember>> fetchMemberList() async {
    final token = await storage.read(key: 'token');
    _isLoading = true;
    notifyListeners();
    _memberList = await _retrofitService.getMemberList('Bearer $token');
    _isLoading = false;
    notifyListeners();
    return _memberList;
  }
}
