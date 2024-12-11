/*
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_110/auth_service.dart';
import 'Login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();

  // 회원가입 로직
  void _signup() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      _showErrorDialog('모든 필드를 입력해주세요.');
      return;
    }

    try {
      final user = await _authService.registerWithEmail(email, password);
      if (user != null) {
        // 회원가입 성공 시
        _showSuccessDialog('회원가입이 완료되었습니다.');
      } else {
        _showErrorDialog('회원가입에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      _showErrorDialog('오류 발생: $e');
    }
  }

  // 성공 다이얼로그
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('성공'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 오류 다이얼로그
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
                    const SizedBox(height: 20),
                    // 이름 입력 필드
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: '이름',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 회원가입 버튼
                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(80, 255, 53, 1),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 하단 텍스트
              RichText(
                text: TextSpan(
                  text: '이미 계정이 있으신가요? ',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
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
import 'package:flutter_application_110/auth_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();

  // 회원가입 로직
  void _signup() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      _showErrorDialog('모든 필드를 입력해주세요.');
      return;
    }

    try {
      // Firebase Authentication에 사용자 등록
      final user = await _authService.registerWithEmail(email, password);
      if (user != null) {
        // 이메일을 키로 변환 ('.'을 '_'로 치환)
        String sanitizedEmail = email.replaceAll('.', '_');

        await FirebaseDatabase.instance.ref('users/$sanitizedEmail').set({
          'email': email,
          'password': password, // 실제 앱에서는 비밀번호를 저장하지 않는 것이 좋습니다.
          'name': name,
          'context' : '목표를 입력하세요'
        });

// subjects 필드에 고유값으로 데이터 추가
        final subjectsRef = FirebaseDatabase.instance.ref('users/$sanitizedEmail/subjects');

// 과목 데이터 배열
        final subjects = [
          {
            'name': '과목 1',
            'tasks': [
              {'title': '오늘의 할 일 1'},
              {'title': '오늘의 할 일 2'}
            ]
          },
          {
            'name': '과목 2',
            'tasks': [
              {'title': '오늘의 할 일 1'},
              {'title': '오늘의 할 일 2'}
            ]
          },
          {
            'name': '과목 3',
            'tasks': [
              {'title': '오늘의 할 일 1'},
              {'title': '오늘의 할 일 2'}
            ]
          },
        ];

        for (var subject in subjects) {
          final newSubjectKey = subjectsRef.push().key; // 고유값 생성
          if (newSubjectKey != null) {
            // 과목 데이터 추가
            final subjectRef = subjectsRef.child(newSubjectKey);
            await subjectRef.set({'name': subject['name']});

            // tasks 데이터 추가
            final tasksRef = subjectRef.child('tasks');
            final tasks = subject['tasks'] as List<dynamic>?; // tasks 데이터 가져오기
            if (tasks != null) {
              for (var task in tasks) {
                final newTaskKey = tasksRef.push().key; // task의 고유값 생성
                if (newTaskKey != null) {
                  await tasksRef.child(newTaskKey).set(task); // 개별 task 추가
                }
              }
            }
          }
        }


        // 회원가입 성공
        _showSuccessDialog('회원가입이 완료되었습니다.');
      } else {
        _showErrorDialog('회원가입에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      _showErrorDialog('오류 발생: $e');
    }
  }

  // 성공 다이얼로그
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('성공'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 오류 다이얼로그
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
                    const SizedBox(height: 20),
                    // 이름 입력 필드
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: '이름',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 회원가입 버튼
                    ElevatedButton(
                      onPressed: _signup,
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
                        '회원가입',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 하단 텍스트
              RichText(
                text: TextSpan(
                  text: '이미 계정이 있으신가요? ',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
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
