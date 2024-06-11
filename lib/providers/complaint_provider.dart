import 'package:flutter/material.dart';
import 'package:office_user/services/api_service.dart';

import '../models/complaint_model.dart';

class ComplaintProvider with ChangeNotifier {

  List<Complaint> _complaintList = [];
  bool _isLoading = false;

  List<Complaint> get complaintList => _complaintList;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
  }

  Future<List<Complaint>> fetchComplaints() async {
    setLoading(true);
    _complaintList = await ApiService.getComplaintList();
    setLoading(false);
    notifyListeners();
    return _complaintList;
  }

  Future<void> registerComplaint(int roomId, String complaintMessage) async {
    setLoading(true);
    await ApiService.registerComplaint(roomId, complaintMessage);
    fetchComplaints();
    notifyListeners();
    setLoading(false);
  }
}