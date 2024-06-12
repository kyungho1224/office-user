import 'package:dio/dio.dart';
import 'package:office_user/models/score_model.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../models/auth_member_model.dart';
import '../models/contract_model.dart';
import '../models/tenant_model.dart';

part 'retrofit_service.g.dart';

// @RestApi(baseUrl: "https://officeback.site")
@RestApi(baseUrl: "http://10.0.2.2:8080")
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
}
