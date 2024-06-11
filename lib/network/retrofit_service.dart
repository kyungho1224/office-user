import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/tenant_model.dart';

part 'retrofit_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080")
abstract class RetrofitService {
  factory RetrofitService(Dio dio, {String baseUrl}) = _RetrofitService;

  @GET("/public-api/tenants")
  Future<TenantList> getTenantList();
}
