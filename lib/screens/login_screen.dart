import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:office_user/models/member_model.dart';
import 'package:office_user/screens/join_screen.dart';
import 'package:office_user/screens/nav_screen.dart';
import 'package:office_user/widgets/custom_alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/retrofit_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isLoading = false;

  // late MemberLoginResponse member;
  late SharedPreferences prefs;
  late Member member;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    if (email != null && password != null) {
      _email = email;
      _password = password;
    }
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        const storage = FlutterSecureStorage();
        final RetrofitService _retrofitService = RetrofitService(Dio());

        final body = <String, dynamic>{'email': _email, 'password': _password};
        member = await _retrofitService.loginMember(body);

        setState(() {
          _isLoading = false;
        });
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setString('token', member.token);
        await storage.write(key: 'token', value: member.token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavScreen(),
          ),
        );
      } on DioException catch (e) {
        setState(() {
          _isLoading = false;
        });
        showCustomDialog(
          context: context,
          title: "로그인 실패",
          content: e.toString(),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("확인"))
          ],
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
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
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  height: 10,
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
                  height: 20,
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        icon: const Icon(
                          Icons.login_outlined,
                          size: 18,
                        ),
                        iconAlignment: IconAlignment.end,
                        onPressed: _login,
                        label: const Text('로그인'),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        notYetModalBottomSheet(context);
                      },
                      child: const Text('아이디 찾기'),
                    ),
                    TextButton(
                      onPressed: () {
                        notYetModalBottomSheet(context);
                      },
                      child: const Text('비밀번호 찾기'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JoinScreen(),
                          ),
                        );
                      },
                      child: const Text('회원가입'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void notYetModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              '준비중입니다!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }
}
