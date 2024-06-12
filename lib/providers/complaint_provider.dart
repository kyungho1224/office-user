import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/complaint_model.dart';
import '../network/retrofit_service.dart';

class ComplaintProvider with ChangeNotifier {
  static const storage = FlutterSecureStorage();
  final RetrofitService _retrofitService = RetrofitService(Dio());

  List<Complaint> _complaintList = [];
  bool _isLoading = false;

  List<Complaint> get complaintList => _complaintList;

  bool get isLoading => _isLoading;

  Future<List<Complaint>> fetchComplaints() async {
    final token = await storage.read(key: 'token');
    _isLoading = true;
    _complaintList = await _retrofitService.getComplaintList('Bearer $token');
    _isLoading = false;
    notifyListeners();
    return _complaintList;
  }

  Future<void> registerComplaint(int roomId, String complaintMessage) async {
    final token = await storage.read(key: 'token');
    _isLoading = true;

    final body = <String, dynamic>{
      'room_id': roomId,
      'complaint_message': complaintMessage
    };
    try {
      await _retrofitService.registerComplaint('Bearer $token', body);
    } on DioException catch (e) {
      if (e.response == null) {
        print("Request failed with status code: ${e.response!.statusCode}");
      } else {
        print("Network Error : $e}");
      }
    }

    fetchComplaints();
    notifyListeners();
    _isLoading = false;
  }
}
