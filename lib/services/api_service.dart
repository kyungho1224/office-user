import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:office_user/models/alarm_model.dart';
import 'package:office_user/models/auth_member_model.dart';
import 'package:office_user/models/complaint_model.dart';
import 'package:office_user/models/contract_model.dart';
import 'package:office_user/models/score_model.dart';
import 'package:office_user/models/tenant_model.dart';

import '../models/member_model.dart';

class ApiService {
  static final storage = FlutterSecureStorage();

  static String base_url =
      Platform.isIOS ? "http://localhost:8080" : "http://10.0.2.2:8080";

  // static String base_url = "https://officeback.site";
  static const String login_url = "public-api/sign-in/user";
  // static const String tenant_list = "public-api/tenants";
  static const String join_url = "public-api/sign-up/user";
  // static const String my_info_url = "app/members/info";
  // static const String contract_list = "app/contracts";
  // static const String score_list = "app/scores";
  static const String member_list = "app/members/all";
  // static const String submit_score = "api/scores";
  static const String alarm_list = "app/alarms";
  static const String complaint_url = "app/complaints";

  static Future<bool> hasNewAlarm() async {
    final token = await storage.read(key: 'token');
    Uri url = Uri.parse("$base_url/$alarm_list/is-new");
    final response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200 && response.body.toLowerCase() == 'true';
  }

  static Future<List<Complaint>> getComplaintList() async {
    final token = await storage.read(key: 'token');
    Uri url = Uri.parse("$base_url/$complaint_url");
    final response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
    return list.map((complaint) => Complaint.fromJson(complaint)).toList();
  }

  static Future<bool> registerComplaint(
      int roomId, String complaintMessage) async {
    final token = await storage.read(key: 'token');
    Uri url = Uri.parse("$base_url/$complaint_url");
    final response = await post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json
          .encode({'room_id': roomId, 'complaint_message': complaintMessage}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> readAlarm(int id) async {
    final token = await storage.read(key: 'token');
    Uri url = Uri.parse("$base_url/$alarm_list/$id");
    final response = await patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }

  static Future<List<Alarm>> getAlarmList() async {
    final token = await storage.read(key: 'token');
    Uri url = Uri.parse("$base_url/$alarm_list");
    final response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
    return list.map((alarm) => Alarm.fromJson(alarm)).toList();
  }

  // static Future<bool> sendScore(int id, int score, String comment) async {
  //   final token = await storage.read(key: 'token');
  //   Uri url = Uri.parse("$base_url/$submit_score/$id");
  //   print("url: $url");
  //   final response = await patch(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: json.encode({'score': score, 'comment': comment}),
  //   );
  //   return response.statusCode == 200;
  // }

  static Future<List<AuthMember>> getMemberList() async {
    final token = await storage.read(key: 'token');
    Uri url = Uri.parse("$base_url/$member_list");
    final response = await get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
    return list.map((member) => AuthMember.fromJson(member)).toList();
  }

  // static Future<List<Score>> getScoreList() async {
  //   final token = await storage.read(key: 'token');
  //   Uri url = Uri.parse("$base_url/$score_list");
  //   final response = await get(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
  //   // print(list);
  //   return list.map((score) => Score.fromJson(score)).toList();
  // }

  // static Future<ContractList> getContractList() async {
  //   final token = await storage.read(key: 'token');
  //   Uri url = Uri.parse("$base_url/$contract_list");
  //   final response = await get(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   return ContractList.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  // }

  // static Future<AuthMember> getMemberInfo() async {
  //   final token = await storage.read(key: 'token');
  //   Uri url = Uri.parse("$base_url/$my_info_url");
  //   final response = await get(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   return AuthMember.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  // }

  static Future<MemberLoginResponse> getMemberLoginResponse(
      String email, String password) async {
    Uri url = Uri.parse("$base_url/$login_url");
    print("login url : ${url}");
    final response = await post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      var memberLoginResponse = MemberLoginResponse.of(
          response.statusCode, "success", json.decode(response.body));

      String token = memberLoginResponse.member!.token;
      await storage.write(key: 'token', value: token);
      return memberLoginResponse;
    }
    return MemberLoginResponse.of(response.statusCode, response.body, null);
  }

  static Future<MemberRegisterResponse> getMemberJoinResponse(
      String email, String password, String phoneNumber, int tenantId) async {
    Uri url = Uri.parse("$base_url/$join_url");
    final response = await post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
          'tenant_id': tenantId
        }));
    if (response.statusCode == 200) {
      return MemberRegisterResponse.fromJson(response.statusCode, "success",
          json.decode(utf8.decode(response.bodyBytes)));
    }
    return MemberRegisterResponse.fromJson(
        response.statusCode, response.body, null);
  }
}
