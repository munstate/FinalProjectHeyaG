import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'footer.dart';
import 'SubjectTimerProvider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'UserProvider.dart'; // UserProvider 가져오기

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({Key? key}) : super(key: key);

  @override
  _PlannerScreenState createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  int _selectedIndex = 1; // 현재 선택된 탭 인덱스
  String dailyQuote = ""; // 오늘의 한마디
  final List<Map<String, dynamic>> _subjects = []; // 과목 리스트

  @override
  void initState() {
    super.initState();
    _fetchDailyQuote();
    _fetchSubjects();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _fetchDailyQuote() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email != null) {
      final snapshot = await FirebaseDatabase.instance
          .ref('users/$email/context')
          .get();
      if (snapshot.exists) {
        setState(() {
          dailyQuote = snapshot.value.toString();
        });
      } else {
        setState(() {
          dailyQuote = "오늘 걸어야 내일 뛰지 않는다."; // 기본 문구
        });
      }
    }
  }
/*
  void _fetchSubjects() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email != null) {
      final snapshot =
      await FirebaseDatabase.instance.ref('users/$email/subjects').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _subjects.clear();
          _subjects.addAll(data.values.map((subject) {
            return {
              "name": subject['name'],
              "subTasks": (subject['tasks'] ?? {}).values.toList()
            };
          }).toList());
        });
      }
    }
  }

 */

  void _fetchSubjects() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email != null) {
      final snapshot =
      await FirebaseDatabase.instance.ref('users/$email/subjects').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _subjects.clear();
          data.forEach((key, value) {
            _subjects.add({
              'key': key, // subject의 고유 키 추가
              'name': value['name'],
              'subTasks': (value['tasks'] ?? {}).entries.map((entry) {
                return {
                  'key': entry.key, // task의 고유 키 추가
                  'title': entry.value['title'],
                  'completed': entry.value['completed'] ?? false,
                };
              }).toList(),
            });
          });
          _subjects.sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  return _buildSubjectCard(index);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: const Color.fromRGBO(80, 255, 53, 1),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getFormattedDate(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Consumer<SubjectTimerProvider>(
                builder: (context, provider, child) {
                  return Text(
                    "TODAY TOTAL ${provider.totalElapsedTime}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Color.fromRGBO(80, 255, 53, 1),
            thickness: 1.0,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dailyQuote.isEmpty ? "Loading..." : dailyQuote,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              IconButton(
                onPressed: _editQuote,
                icon: const Icon(
                    Icons.edit, color: Color.fromRGBO(80, 255, 53, 1)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(int index) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _subjects[index]['name'],
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            const Divider(color: Colors.white, thickness: 1),
            Column(
              children: List.generate(
                  _subjects[index]['subTasks'].length, (subIndex) {
                return _buildSubTask(index, subIndex);
              }),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  _addSubTask(index);
                },
                icon: const Icon(
                    Icons.add, color: Color.fromRGBO(80, 255, 53, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  Widget _buildSubTask(int subjectIndex, int subIndex) {
    bool isCompleted = _subjects[subjectIndex]['subTasks'][subIndex]['completed'] ??
        false;
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.circle,
            color: isCompleted ? Colors.green : Colors.white,
          ),
          onPressed: () {
            setState(() {
              _subjects[subjectIndex]['subTasks'][subIndex]['completed'] =
              !isCompleted;
            });
          },
        ),
        Expanded(
          child: Text(
            _subjects[subjectIndex]['subTasks'][subIndex]['title'] ?? "",
            style: TextStyle(
              color: Colors.white,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _deleteSubTask(subjectIndex, subIndex);
          },
        ),
      ],
    );
  }

   */

  Widget _buildSubTask(int subjectIndex, int subIndex) {
    bool isCompleted = _subjects[subjectIndex]['subTasks'][subIndex]['completed'] ?? false;
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.circle,
            color: isCompleted ? Colors.green : Colors.white,
          ),
          onPressed: () {
            _toggleTaskCompletion(subjectIndex, subIndex, !isCompleted);
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _editSubTask(subjectIndex, subIndex);
            },
            child: Text(
              _subjects[subjectIndex]['subTasks'][subIndex]['title'] ?? "",
              style: TextStyle(
                color: Colors.white,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _deleteSubTask(subjectIndex, subIndex);
          },
        ),
      ],
    );
  }

  void _toggleTaskCompletion(int subjectIndex, int subIndex, bool isCompleted) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_');

    if (email == null) return;

    final subjectKey = _subjects[subjectIndex]['key'];
    final taskKey = _subjects[subjectIndex]['subTasks'][subIndex]['key'];
    final DatabaseReference taskRef = FirebaseDatabase.instance
        .ref('users/$email/subjects/$subjectKey/tasks/$taskKey');

    await taskRef.update({'completed': isCompleted});

    setState(() {
      _subjects[subjectIndex]['subTasks'][subIndex]['completed'] = isCompleted;
    });
  }


  String _getFormattedDate() {
    final now = DateTime.now();
    final weekday = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
    return "${now.year}. ${now.month.toString().padLeft(2, '0')}. ${now.day
        .toString().padLeft(2, '0')} ${weekday[now.weekday - 1]}";
  }



  void _addSubTask(int subjectIndex) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email == null) return;

    // 과목의 고유 키를 정확히 가져옴
    final subjectKey = _subjects[subjectIndex]['key'];
    if (subjectKey == null) {
      print("Subject key is null for index $subjectIndex");
      return;
    }

    // 과목의 tasks 경로를 설정
    final DatabaseReference tasksRef = FirebaseDatabase.instance
        .ref('users/$email/subjects/$subjectKey/tasks');
    final newTaskKey = tasksRef.push().key; // task의 고유 키 생성

    if (newTaskKey != null) {
      await tasksRef.child(newTaskKey).set({
        'title': '새로운 할 일',
        'completed': false,
      });

      setState(() {
        _subjects[subjectIndex]['subTasks'].add({
          'key': newTaskKey,
          'title': '새로운 할 일',
          'completed': false,
        });
      });
    } else {
      print("Failed to generate task key");
    }
  }

  void _editSubTask(int subjectIndex, int subIndex) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email == null) return;

    // 과목의 고유 키와 task의 고유 키를 정확히 가져옴
    final subjectKey = _subjects[subjectIndex]['key'];
    final taskKey = _subjects[subjectIndex]['subTasks'][subIndex]['key'];

    if (subjectKey == null || taskKey == null) {
      print("Subject key or Task key is null");
      return;
    }

    final DatabaseReference taskRef = FirebaseDatabase.instance
        .ref('users/$email/subjects/$subjectKey/tasks/$taskKey');

    TextEditingController controller = TextEditingController(
      text: _subjects[subjectIndex]['subTasks'][subIndex]['title'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("할 일 수정"),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedTitle = controller.text;
                await taskRef.update({'title': updatedTitle}); // Firebase에서 제목 업데이트

                setState(() {
                  _subjects[subjectIndex]['subTasks'][subIndex]['title'] = updatedTitle;
                });

                Navigator.pop(context);
              },
              child: const Text("저장"),
            ),
          ],
        );
      },
    );
  }

  void _deleteSubTask(int subjectIndex, int subIndex) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final email = userProvider.email?.replaceAll('.', '_'); // Firebase 키 형식 변환

    if (email == null) return;

    // 과목의 고유 키와 task의 고유 키를 정확히 가져옴
    final subjectKey = _subjects[subjectIndex]['key'];
    final taskKey = _subjects[subjectIndex]['subTasks'][subIndex]['key'];

    if (subjectKey == null || taskKey == null) {
      print("Subject key or Task key is null");
      return;
    }

    final DatabaseReference taskRef = FirebaseDatabase.instance
        .ref('users/$email/subjects/$subjectKey/tasks/$taskKey');

    await taskRef.remove(); // Firebase에서 task 삭제

    setState(() {
      _subjects[subjectIndex]['subTasks'].removeAt(subIndex); // 로컬 데이터에서도 제거
    });
  }


  void _editQuote() {
    TextEditingController controller = TextEditingController(text: dailyQuote);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("문구 수정"),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                final userProvider = Provider.of<UserProvider>(
                    context, listen: false);
                final email = userProvider.email?.replaceAll('.', '_');

                if (email != null) {
                  FirebaseDatabase.instance
                      .ref('users/$email/context')
                      .set(controller.text);
                  setState(() {
                    dailyQuote = controller.text;
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("저장"),
            ),
          ],
        );
      },
    );
  }
}
  /*
  void _deleteSubTask(int subjectIndex, int subIndex) {
    setState(() {
      _subjects[subjectIndex]['subTasks'].removeAt(subIndex);
    });
  }
}



   */