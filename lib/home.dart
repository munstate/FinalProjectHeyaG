
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'SubjectTimerProvider.dart';
import 'SujPopup.dart';
import 'todoPopup.dart';
import 'footer.dart';
import 'UserProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // 현재 선택된 탭 인덱스
  bool _showTodoList = false; // To-Do List 화면 여부
  String _totalElapsedTime = '00:00:00'; // 총 시간
  List<String> _subjects = List.from(["과목 1", "과목 2", "과목 3"]); // 과목 리스트
  List<String> _todoList = List.from(["To-do1", "To-do2", "To-do3"]); // To-Do 리스트
  List<bool> _todoCompletionStatus = List.from([false, false, false]); // 각 To-Do 항목의 완료 상태

  // 완료된 To-Do 항목 수
  int get _completedTodoCount {
    return _todoCompletionStatus.where((status) => status).length;
  }

  // 진행 상황 비율 계산
  double get _progress {
    if (_todoList.isEmpty) return 0.0;
    return _completedTodoCount / _todoList.length;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final subjectTimerProvider = Provider.of<SubjectTimerProvider>(context, listen: false);
      subjectTimerProvider.loadSubjects(context); // 여기서 Firebase 데이터 로드
      _updateTotalTime(); // 초기화 후 총 시간을 업데이트
    });
  }

  // reset 버튼 클릭 시
  void _reset() {
    final subjectTimerProvider = Provider.of<SubjectTimerProvider>(context, listen: false);
    subjectTimerProvider.resetAll(); // 전체 시간과 과목 시간을 초기화
    setState(() {
      _totalElapsedTime = subjectTimerProvider.totalElapsedTime; // 총 시간 상태 갱신
    });
  }

  // 총 시간 업데이트
  void _updateTotalTime() {
    final subjectTimerProvider =
    Provider.of<SubjectTimerProvider>(context, listen: false);

    int totalMilliseconds = subjectTimerProvider.elapsedTimes.values
        .map((time) => _parseDuration(time).inMilliseconds)
        .fold(0, (sum, current) => sum + current);

    setState(() {
      _totalElapsedTime = _formatTime(totalMilliseconds);
    });
  }

  // 시간을 형식화하는 메서드
  String _formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  Duration _parseDuration(String time) {
    final parts = time.split(':').map(int.parse).toList();
    return Duration(
      hours: parts[0],
      minutes: parts[1],
      seconds: parts[2],
    );
  }

  // 진행 상황 그래프
  Widget _buildProgressBar() {
    return Stack(
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[700],
          ),
        ),
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width * _progress, // 진행상황 반영
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(80, 255, 53, 1),
          ),
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              "${(_progress * 100).toStringAsFixed(0)}%",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // To-Do 리스트 빌드
  Widget _buildTodoList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _todoList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                // 완료 상태 토글
                _todoCompletionStatus[index] = !_todoCompletionStatus[index];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _todoCompletionStatus[index]
                    ? Colors.grey[800]
                    : const Color.fromRGBO(80, 255, 53, 1),
              ),
              child: ListTile(
                leading: Icon(
                  _todoCompletionStatus[index]
                      ? Icons.check_circle
                      : Icons.circle,
                  color: _todoCompletionStatus[index]
                      ? Colors.white
                      : Colors.white,
                ),
                title: Text(
                  _todoList[index],
                  style: TextStyle(
                    color: _todoCompletionStatus[index]
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildTotalTime() {
    return Consumer<SubjectTimerProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(80, 255, 53, 1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "TOTAL TIME",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                provider.totalElapsedTime, // 실시간 업데이트된 값
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(80, 255, 53, 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildSubjectList() {
    final subjectTimerProvider = Provider.of<SubjectTimerProvider>(context, listen: true);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: subjectTimerProvider.subjects.length,
      itemBuilder: (context, index) {
        final subjectName = subjectTimerProvider.subjects[index];
        final isActive = subjectTimerProvider.activeSubject == subjectName;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[800],
            ),
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  subjectTimerProvider.timers[subjectName]?.isRunning ?? false
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: isActive ? Colors.green : Colors.white,
                ),
                onPressed: isActive || subjectTimerProvider.activeSubject == null
                    ? () {
                  if (subjectTimerProvider.timers[subjectName]?.isRunning ?? false) {
                    subjectTimerProvider.stopTimer(subjectName);
                  } else {
                    subjectTimerProvider.startTimer(subjectName);
                  }
                }
                    : null, // 다른 과목 활성화 시 버튼 비활성화
              ),
              title: Text(
                subjectName,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: Text(
                subjectTimerProvider.elapsedTimes[subjectName] ?? "00:00:00",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }


  // 과목 팝업 띄우기 메서드
  void _showPopup() {
    final subjectTimerProvider = Provider.of<SubjectTimerProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return PopupScreen(
          subjects: subjectTimerProvider.subjects,
          onDeleteSubject: (int index) {
            setState(() {
              subjectTimerProvider.deleteSubject(context,index); // SubjectTimerProvider에서 과목 삭제
              _totalElapsedTime = subjectTimerProvider.totalElapsedTime; // 총 시간 업데이트
            });
          },
          onAddSubject: (String newSubject) {
            setState(() {
              subjectTimerProvider.addSubject(context, newSubject); // SubjectTimerProvider에서 과목 추가
              _totalElapsedTime = subjectTimerProvider.totalElapsedTime; // 총 시간 업데이트
            });
          },
          onEditSubject: (int index, String newName) {
            print("onEditSubject called with index: $index, newName: $newName");
            setState(() {
              subjectTimerProvider.editSubject(context, index, newName); // SubjectTimerProvider에서 과목 수정
              _totalElapsedTime = subjectTimerProvider.totalElapsedTime; // 총 시간 업데이트
            });
          },
        );
      },
    );
  }



  // To-Do List 관리용 팝업 띄우기
  void _showtodoPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return tdPopupScreen(
          todoList: List.from(_todoList),
          onAddTodo: (newTodo) {
            setState(() {
              _todoList.add(newTodo);
              _todoCompletionStatus.add(false);// To-Do 항목 추가
            });
          },
          onEditTodo: (index, updatedTodo) {
            setState(() {
              if (index >= 0 && index < _todoList.length) {
                _todoList[index] = updatedTodo; // To-Do 항목 수정
              }
            });
          },
          onDeleteTodo: (index) {
            if (index >= 0 && index < _todoList.length) {
              setState(() {
                _todoList.removeAt(index);
                _todoCompletionStatus.removeAt(index);// To-Do 항목 삭제
              });
            }
          },
        );
      },
    );
  }

  // 탭 선택 이벤트
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); // UserProvider에서 사용자 정보 가져오기
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '${userProvider.name} 님, 어서오세요!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // 상단 타이머 영역
              Consumer<SubjectTimerProvider>(
                builder: (context, provider, child) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(80, 255, 53, 1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          "TOTAL TIME",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          provider.totalElapsedTime, // 실시간 업데이트된 값
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(80, 255, 53, 1),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // 진행 상황 그래프
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘의 진행상황 그래프',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.greenAccent, thickness: 1),
                ],
              ),

              // 관리 버튼
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: _showTodoList ? _showtodoPopup : _showPopup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    _showTodoList ? "+to-do" : "+과목",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // 동적 콘텐츠 전환
              _showTodoList ? _buildTodoList() : _buildSubjectList(),

              const SizedBox(height: 16),

              // To-Do List 전환 버튼
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showTodoList = !_showTodoList; // To-Do List와 과목 리스트 전환
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(80, 255, 53, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 12),
                ),
                child: Text(
                  _showTodoList ? "과목 보기" : "To-Do List",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              // Reset 버튼
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "전체 시간 및 과목 초기화",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}


