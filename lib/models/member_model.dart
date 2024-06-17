class Member {
  String email, role, token;

  Member.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        role = json['role'],
        token = json['token'];
}

// class MemberLoginResponse {
//   final int code;
//   final String message;
//   final Member? member;
//
//   MemberLoginResponse.of(this.code, this.message, Map<String, dynamic>? json)
//       : member = json != null ? Member.fromJson(json) : null;
// }

class MemberRegister {
  final int id;
  final String email, role, phoneNumber, status;

  MemberRegister.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        role = json['role'],
        phoneNumber = json['phone_number'],
        status = json['status'];
}

// class MemberRegisterResponse {
//   final int code;
//   final String message;
//   final MemberRegister? memberRegister;
//
//   MemberRegisterResponse.fromJson(
//       this.code, this.message, Map<String, dynamic>? json)
//       : memberRegister = json != null ? MemberRegister.fromJson(json) : null;
// }
