import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart'; // UserProvider 참조를 위해 필요
import 'UserProvider.dart'; // UserProvider 가져오기
import 'package:firebase_database/firebase_database.dart'; // Firebase Database import

class SubjectTimerProvider with ChangeNotifier {
  final List<String> _subjects = [];
  final Map<String, Stopwatch> _timers = {};
  final Map<String, String> _elapsedTimes = {};
  final Map<String, Timer?> _updateTimers = {};
  late Timer _totalUpdateTimer; // 전체 시간 업데이트를 위한 타이머
  late SharedPreferences _prefs;

  String? _activeSubject; // 현재 활성화된 과목 이름
  String? get activeSubject => _activeSubject;

  String _totalElapsedTime = "00:00:00";
  String get totalElapsedTime => _totalElapsedTime;

  // Getter
  Map<String, String> get elapsedTimes => _elapsedTimes;
  List<String> get subjects => List.unmodifiable(_subjects);
  Map<String, Stopwatch> get timers => _timers;


  SubjectTimerProvider() {
    // 전체 시간 업데이트 타이머 초기화
    _totalUpdateTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _updateTotalElapsedTime(),
    );
  }

  Future<void> loadSubjects(BuildContext context) async {
    // UserProvider에서 사용자 이메일 가져오기
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email == null) {
      print("사용자 이메일 없음");
      return;
    }

    try {
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref('users/$email/subjects');
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        _subjects.clear(); // 기존 데이터 초기화
        final data = snapshot.value as Map; // 타입 강제 지정 없이 사용

        // Firebase에서 모든 과목 이름 추가
        data.forEach((key, value) {
          if (value is Map && value.containsKey('name')) {
            _subjects.add(value['name']); // 과목 이름 저장
          }
        });

        // 과목 이름을 정렬
        _subjects.sort(); // 알파벳 또는 한글 순서로 정렬

        notifyListeners(); // UI 업데이트
        print("Firebase에서 정렬된 과목 데이터 로드 성공: $_subjects");
      } else {
        print("Firebase에서 과목 데이터 없음");
      }
    } catch (e) {
      print("Firebase 데이터 로드 실패: $e");
    }
  }
  // 전체 시간과 과목 시간 초기화 메서드
  void resetAll() {
    // 전체 시간 초기화
    _totalElapsedTime = "00:00:00";

    // 각 과목의 타이머와 경과 시간 초기화
    _timers.forEach((subjectName, stopwatch) {
      stopwatch.reset();
      _elapsedTimes[subjectName] = "00:00:00";
    });

    // 초기화 후 상태 갱신
    notifyListeners();
  }

  Future<void> initialize() async {
    print("Initializing SubjectTimerProvider...");
    _prefs = await SharedPreferences.getInstance();
    await clearSharedPreferences();
    print("Subjects after clearing SharedPreferences: $_subjects");

  }

  Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 모든 저장 데이터 초기화
    _subjects.clear(); // 메모리 상의 데이터 초기화
    _timers.clear();
    _elapsedTimes.clear();
    print("SharedPreferences and local variables cleared.");
  }

  void addSubject(BuildContext context, String subjectName) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email == null) {
      print("사용자 이메일 없음");
      return;
    }

    try {
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref('users/$email/subjects');
      final newSubjectKey = dbRef.push().key; // 고유 키 생성

      if (newSubjectKey != null) {
        // Firebase에 새로운 과목 추가
        final DatabaseReference newSubjectRef = dbRef.child(newSubjectKey);
        final taskKey = newSubjectRef.child('tasks').push().key; // 고유 키 생성

        await newSubjectRef.set({
          'name': subjectName,
          'tasks': {
            taskKey: {
              'title': '오늘의 할 일',
              'completed': false,
            },
          },
        });

        // 로컬 데이터에 반영
        _timers[subjectName] = Stopwatch();
        _elapsedTimes[subjectName] = "00:00:00";
        _subjects.add(subjectName); // 리스트에 과목 추가

        print("Subject added: $subjectName");
        notifyListeners(); // UI 업데이트
      }
    } catch (e) {
      print("과목 추가 실패: $e");
    }
  }

  void deleteSubject(BuildContext context, int index) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email == null) {
      print("사용자 이메일 없음");
      return;
    }

    if (index < 0 || index >= _subjects.length) {
      print("잘못된 인덱스: $index");
      return;
    }

    try {
      final subjectName = _subjects[index];

      // Firebase에서 과목 삭제
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref('users/$email/subjects');
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;

        // Firebase에서 해당 과목의 키 찾기
        final keyToDelete = data.keys.firstWhere(
              (key) => data[key]['name'] == subjectName,
          orElse: () => null,
        );

        if (keyToDelete != null) {
          await dbRef.child(keyToDelete).remove(); // Firebase에서 삭제
          print("Firebase에서 과목 삭제: $subjectName");
        }
      }

      // 로컬 데이터에서 삭제
      _timers.remove(subjectName);
      _elapsedTimes.remove(subjectName);
      _subjects.removeAt(index);

      print("로컬에서 과목 삭제: $subjectName");
      notifyListeners(); // UI 업데이트
    } catch (e) {
      print("과목 삭제 실패: $e");
    }
  }

  void editSubject(BuildContext context, int index, String newSubjectName) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email == null) {
      print("사용자 이메일 없음");
      return;
    }

    if (index < 0 || index >= _subjects.length) {
      print("잘못된 인덱스: $index");
      return;
    }

    try {
      final oldSubjectName = _subjects[index];

      // Firebase에서 과목 수정
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref('users/$email/subjects');
      final snapshot = await dbRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;

        // Firebase에서 해당 과목의 키 찾기
        final keyToUpdate = data.keys.firstWhere(
              (key) => data[key]['name'] == oldSubjectName,
          orElse: () => null,
        );

        if (keyToUpdate != null) {
          // Firebase에서 과목 이름 업데이트
          await dbRef.child(keyToUpdate).update({'name': newSubjectName});
          print("Firebase에서 과목 수정: $oldSubjectName -> $newSubjectName");
        }
      }

      // 로컬 데이터 수정
      if (_timers.containsKey(oldSubjectName)) {
        _timers[newSubjectName] = _timers.remove(oldSubjectName)!;
      }
      if (_elapsedTimes.containsKey(oldSubjectName)) {
        _elapsedTimes[newSubjectName] = _elapsedTimes.remove(oldSubjectName)!;
      }
      _subjects[index] = newSubjectName;

      print("로컬에서 과목 수정: $oldSubjectName -> $newSubjectName");
      notifyListeners(); // UI 업데이트
    } catch (e) {
      print("과목 수정 실패: $e");
    }
  }

  // 타이머 시작
  void startTimer(String subjectName) {
    if (_activeSubject == null) {
      _timers[subjectName] ??= Stopwatch();
      _timers[subjectName]!.start();
      _activeSubject = subjectName;
      _updateTimers[subjectName] = Timer.periodic(
        const Duration(seconds: 1),
            (_) {
          _updateElapsedTime(subjectName);
          _updateTotalElapsedTime(); // TOTAL TIME 업데이트
        },
      );
      notifyListeners();
    }
  }

  // 타이머 중지
  void stopTimer(String subjectName) {
    if (_timers[subjectName]?.isRunning ?? false) {
      _timers[subjectName]?.stop();
      _updateTimers[subjectName]?.cancel();
      _updateElapsedTime(subjectName);
      _activeSubject = null;
      _updateTotalElapsedTime(); // TOTAL TIME 업데이트
      notifyListeners();
    }
  }

  // 타이머 리셋
  void resetTimer(String subjectName) {
    if (_timers.containsKey(subjectName)) {
      _timers[subjectName]!.reset();
      _elapsedTimes[subjectName] = "00:00:00"; // 시간 리셋
      notifyListeners(); // 상태 변경 알림
    }
  }

  // 경과 시간 업데이트
  void _updateElapsedTime(String subjectName) {
    if (_timers.containsKey(subjectName)) {
      final stopwatch = _timers[subjectName]!;
      final elapsed = stopwatch.elapsed;
      _elapsedTimes[subjectName] = _formatDuration(elapsed);
      notifyListeners(); // 상태 변경 알림
    }
  }

  // 전체 시간 업데이트
  void _updateTotalElapsedTime() {
    // 모든 타이머의 총 경과 시간 계산
    int totalMilliseconds = _timers.values.fold(0, (sum, stopwatch) {
      return sum + stopwatch.elapsedMilliseconds;
    });

    _totalElapsedTime = _formatDuration(Duration(milliseconds: totalMilliseconds));
    notifyListeners(); // 전체 시간 상태 변경 알림
  }

  // SharedPreferences에 타이머 저장
  void _saveTimers() {
    final savedTimes = _elapsedTimes.map((key, value) {
      final isRunning = _timers[key]?.isRunning ?? false;
      return MapEntry(
        key,
        json.encode({
          "elapsedTime": value,
          "isRunning": isRunning,
        }),
      );
    });

    // subjects 저장
    _prefs.setString('elapsedTimes', json.encode(savedTimes));
    _prefs.setString('subjects', json.encode(_subjects)); // subjects 저장
    print("Saving subjects: $_subjects");
  }


  // 시간 포맷 변환
  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  // 시간을 Duration 객체로 변환
  Duration _parseDuration(String time) {
    final parts = time.split(':').map(int.parse).toList();
    return Duration(
      hours: parts[0],
      minutes: parts[1],
      seconds: parts[2],
    );
  }

  @override
  void dispose() {
    _totalUpdateTimer.cancel();
    _updateTimers.values.forEach((timer) => timer?.cancel());
    super.dispose();
  }

  // 진행 상황 비율 계산
  double get progress {
    if (_elapsedTimes.isEmpty) return 0.0;

    final totalElapsed = _timers.values
        .map((stopwatch) => stopwatch.elapsedMilliseconds)
        .fold<int>(0, (sum, current) => sum + current);

    const int maxTime = 8 * 60 * 60 * 1000; // 8시간
    return (totalElapsed / maxTime).clamp(0.0, 1.0);
  }
}


