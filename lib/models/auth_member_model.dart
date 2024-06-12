import 'package:office_user/models/tenant_model.dart';

class AuthMember {
  final int id;
  final String email;
  final String phone;
  final Tenant? tenant;

  AuthMember(
      {required this.id,
      required this.email,
      required this.phone,
      required this.tenant});

  AuthMember.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        phone = json['phone_number'],
        tenant = Tenant.fromJson(json['tenant']);
}
