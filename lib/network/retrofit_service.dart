import 'package:dio/dio.dart';
import 'package:office_user/models/alarm_model.dart';
import 'package:office_user/models/complaint_model.dart';
import 'package:office_user/models/score_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_member_model.dart';
import '../models/contract_model.dart';
import '../models/member_model.dart';
import '../models/tenant_model.dart';

part 'retrofit_service.g.dart';

// @RestApi(baseUrl: "https://officeback.site")
@RestApi(baseUrl: "http://10.0.2.2:8080")
// @RestApi(baseUrl: "http://localhost:8080")
abstract class RetrofitService {
  factory RetrofitService(Dio dio, {String baseUrl}) = _RetrofitService;

  @GET("/public-api/tenants")
  Future<TenantList> getTenantList();

  @GET("/app/scores")
  Future<List<Score>> getScoreList(
    @Header("Authorization") String token,
  );

  @PATCH("/api/scores/{id}")
  Future<ScoreResult> updateScore(
    @Header("Authorization") String token,
    @Path("id") int id,
    @Body() Map<String, dynamic> updateScoreRequest,
  );

  @GET("/app/contracts")
  Future<ContractList> getContractList(
    @Header("Authorization") String token,
  );

  @GET("/app/members/info")
  Future<AuthMember> getMemberInfo(
    @Header("Authorization") String token,
  );

  @GET("/app/members/all")
  Future<List<AuthMember>> getMemberList(
    @Header("Authorization") String token,
  );

  @GET("/app/alarms")
  Future<List<Alarm>> getAlarmList(
    @Header("Authorization") String token,
  );

  @PATCH("/app/alarms/{id}")
  Future<int> readAlarm(
    @Header("Authorization") String token,
    @Path('id') int id,
  );

  @GET("/app/alarms/is-new")
  Future<bool> hasNewAlarm(
    @Header("Authorization") String token,
  );

  @POST("/app/complaints")
  Future<void> registerComplaint(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> complaintRequest,
  );

  @GET("/app/complaints")
  Future<List<Complaint>> getComplaintList(
    @Header("Authorization") String token,
  );

  @POST("/public-api/sign-in/user")
  Future<Member> loginMember(
    @Body() Map<String, dynamic> loginRequest,
  );

  @POST("/public-api/sign-up/user")
  Future<MemberRegister> registerMember(
    @Body() Map<String, dynamic> joinRequest,
  );
}
