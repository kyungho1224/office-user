import 'dart:async';

import 'package:flutter/material.dart';
import 'package:office_user/models/member_model.dart';
import 'package:office_user/models/tenant_model.dart';
import 'package:office_user/services/api_service.dart';
import 'package:office_user/widgets/custom_alert_dialog.dart';

class JoinScreen extends StatefulWidget {
  JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _phone = "";
  Tenant? _selectedTenant;
  bool _isLoading = false;
  late MemberRegisterResponse memberJoinResponse;

  void _join() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      if (_selectedTenant == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('입주사를 선택해주세요!'),
          ),
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      memberJoinResponse = await ApiService.getMemberJoinResponse(
          _email, _password, _phone, _selectedTenant!.id);
      if (memberJoinResponse.code == 200) {
        print("success");
        print("role: ${memberJoinResponse.memberRegister!.role}");
        print("status: ${memberJoinResponse.memberRegister!.status}");
        showCustomDialog(
            context: context,
            title: "회원가입 성공",
            content: "메인화면에서 로그인 해주세요",
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text("확인"),
              )
            ]);
      } else {
        print("failed");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(memberJoinResponse.message),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black,
          title: const Text(
            'Office for User',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TenantDropdown(onTenantSelected: (tenant) {
                    setState(() {
                      _selectedTenant = tenant;
                    });
                  }),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onSaved: (value) => _email = value!,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력하세요';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your Email',
                      labelText: 'Email',
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onSaved: (value) => _password = value!,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력하세요';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your Password',
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onSaved: (value) => _phone = value!,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '휴대전화번호를 입력하세요';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your PhoneNumber',
                      labelText: 'PhoneNumber',
                      labelStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: _join,
                    child: const Text('회원가입'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TenantDropdown extends StatefulWidget {
  final Function(Tenant) onTenantSelected;

  const TenantDropdown({required this.onTenantSelected, super.key});

  @override
  State<TenantDropdown> createState() => _TenantDropdownState();
}

class _TenantDropdownState extends State<TenantDropdown> {
  Future<TenantsResponse> tenantList = ApiService.getTenantsResponse();
  Tenant? selectedTenant;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TenantsResponse>(
      future: tenantList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('오류가 발생했습니다.');
        } else if (!snapshot.hasData ||
            snapshot.data!.tenantList!.tenantList.isEmpty) {
          return const Text('입주사 목록이 없습니다.');
        } else {
          return DropdownButton<Tenant>(
            isExpanded: true,
            value: selectedTenant,
            items: snapshot.data!.tenantList!.tenantList.map((Tenant item) {
              return DropdownMenuItem<Tenant>(
                value: item,
                child: Text(
                  '${item.name} (${item.companyNumber})',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              );
            }).toList(),
            onChanged: (Tenant? value) {
              setState(() {
                selectedTenant = value;
              });
              widget.onTenantSelected(value!);
            },
            hint: const Text('입주사를 선택하세요'),
          );
        }
      },
    );
  }
}
