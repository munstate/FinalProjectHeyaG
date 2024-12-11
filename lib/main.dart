/*
import 'package:flutter/material.dart';
import 'package:flutter_application_110/Login.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home.dart'; // HomeScreen 페이지
import 'SubjectTimerProvider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 프레임워크 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 설정
  );

  final subjectTimerProvider = SubjectTimerProvider(); // Provider 생성
  await subjectTimerProvider.initialize(); // SharedPreferences 초기화 및 데이터 복원

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SubjectTimerProvider>(
          create: (_) => subjectTimerProvider, // 앱 전체에서 공유될 Provider
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // 초기 화면 설정
      routes: {
        '/login':(context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(), // HomeScreen 페이지
        // 다른 페이지 경로도 여기에 추가 가능
      },
    );
  }
}

 */

import 'package:flutter/material.dart';
import 'package:flutter_application_110/Login.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home.dart'; // HomeScreen 페이지
import 'SubjectTimerProvider.dart';
import 'UserProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 프레임워크 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase 설정
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SubjectTimerProvider>(
          create: (_) => SubjectTimerProvider(), // SubjectTimerProvider 등록
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(), // UserProvider 등록
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // 초기 화면 설정
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(), // HomeScreen 페이지
      },
    );
  }
}
