/*
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Signup.dart';
import 'home.dart';
import 'package:provider/provider.dart'; // 추가
import 'providers/UserProvider.dart'; // 추가

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('users');

  // 로그인 로직
  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String sanitizedEmail = email.replaceAll('.', '_');

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    try {
      // Realtime Database에서 사용자 정보 조회
      final snapshot = await _dbRef.child(sanitizedEmail).get();

      if (snapshot.exists) {
        final userData = snapshot.value as Map;
        String savedPassword = userData['password'];

        if (password == savedPassword) {
          // 로그인 성공
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          _showErrorDialog('비밀번호가 틀렸습니다.');
        }
      } else {
        _showErrorDialog('존재하지 않는 사용자입니다.');
      }
    } catch (e) {
      _showErrorDialog('오류 발생: $e');
    }
  }

  // 에러 다이얼로그 표시
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고 영역
              Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: screenSize.width * 0.8,
                    height: screenSize.width * 0.8 * 461 / 541,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              // 입력 필드 영역
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    // 이메일 입력 필드
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: '이메일',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 비밀번호 입력 필드
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: '비밀번호',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 로그인 버튼
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(80, 255, 53, 1),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 하단 텍스트
              RichText(
                text: TextSpan(
                  text: '지금 바로 함께하세요! ',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


 */
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Signup.dart';
import 'home.dart';
import 'package:provider/provider.dart'; // Provider 추가
import 'UserProvider.dart'; // UserProvider 추가

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('users');

  // 로그인 로직
  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String sanitizedEmail = email.replaceAll('.', '_');

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('이메일과 비밀번호를 입력해주세요.');
      return;
    }

    try {
      // Realtime Database에서 사용자 정보 조회
      final snapshot = await _dbRef.child(sanitizedEmail).get();

      if (snapshot.exists) {
        final userData = snapshot.value as Map;
        String savedPassword = userData['password'];

        if (password == savedPassword) {
          // UserProvider를 통해 사용자 정보 저장
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(email, userData['name']);

          // 로그인 성공 시 홈 화면으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          _showErrorDialog('비밀번호가 틀렸습니다.');
        }
      } else {
        _showErrorDialog('존재하지 않는 사용자입니다.');
      }
    } catch (e) {
      _showErrorDialog('오류 발생: $e');
    }
  }

  // 에러 다이얼로그 표시
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('오류'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고 영역
              Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: screenSize.width * 0.8,
                    height: screenSize.width * 0.8 * 461 / 541,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              // 입력 필드 영역
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: [
                    // 이메일 입력 필드
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: '이메일',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 비밀번호 입력 필드
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: '비밀번호',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 로그인 버튼
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(80, 255, 53, 1),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 하단 텍스트
              RichText(
                text: TextSpan(
                  text: '지금 바로 함께하세요! ',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

