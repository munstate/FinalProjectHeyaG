import 'package:flutter/material.dart';
import 'home.dart';

import 'package:flutter/material.dart';

class tdPopupScreen extends StatefulWidget {
  final List<String> todoList; // To-Do 리스트
  final Function(String) onAddTodo; // 항목 추가 콜백
  final Function(int, String) onEditTodo; // 항목 수정 콜백
  final Function(int) onDeleteTodo; // 항목 삭제 콜백

  const tdPopupScreen({
    Key? key,
    required this.todoList,
    required this.onAddTodo,
    required this.onEditTodo,
    required this.onDeleteTodo,
  }) : super(key: key);

  @override
  _tdPopupScreenState createState() => _tdPopupScreenState();
}

class _tdPopupScreenState extends State<tdPopupScreen> {
  late List<String> localTodoList; // 로컬 To-Do 리스트
  final TextEditingController _textEditingController = TextEditingController();
  int? editingIndex; // 수정 중인 항목 인덱스

  @override
  void initState() {
    super.initState();
    localTodoList = List.from(widget.todoList); // 수정 가능한 리스트로 초기화
  }

  void _addTodo() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        String newTodo = _textEditingController.text;
        localTodoList.add(newTodo); // 로컬 리스트에 추가
        widget.onAddTodo(newTodo); // 부모 콜백 호출
        _textEditingController.clear(); // 입력 필드 초기화
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      localTodoList.removeAt(index); // 로컬 리스트에서 삭제
      widget.onDeleteTodo(index); // 부모 콜백 호출
    });
  }

  void _editTodo() {
    if (editingIndex != null && _textEditingController.text.isNotEmpty) {
      setState(() {
        localTodoList[editingIndex!] = _textEditingController.text; // 로컬 리스트 수정
        widget.onEditTodo(editingIndex!, _textEditingController.text); // 부모 콜백 호출
        _textEditingController.clear(); // 입력 필드 초기화
        editingIndex = null; // 수정 모드 종료
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        color: Colors.grey[850],
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 제목
            const Text(
              'To-Do-List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // To-Do 리스트
            Expanded(
              child: ListView.builder(
                itemCount: localTodoList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          editingIndex = index; // 수정 모드 설정
                          _textEditingController.text = localTodoList[index]; // 수정할 항목 불러오기
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(80, 255, 53, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.circle, color: Colors.white),
                          title: Text(
                            localTodoList[index],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(index),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 입력 필드 및 추가 버튼
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: '새로운 할 일을 추가하세요',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(80, 255, 53, 1),
                  onPressed: editingIndex == null ? _addTodo : _editTodo,
                  child: const Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 닫기 버튼
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () => Navigator.of(context).pop(),
                backgroundColor: const Color.fromRGBO(80, 255, 53, 1),
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*class tdPopupScreen extends StatefulWidget {
  List<String> todoList; // To-Do List
  final Function(int) onDeleteTodo; // 항목 삭제 콜백
  final Function(String) onAddTodo; // 항목 추가 콜백
  final Function(int, String) onEditTodo; // 항목 수정 콜백

  tdPopupScreen({
    Key? key,
    required this.todoList,
    required this.onDeleteTodo,
    required this.onAddTodo,
    required this.onEditTodo,
  }) : super(key: key);

  @override
  _tdPopupScreenState createState() => _tdPopupScreenState();
}

class _tdPopupScreenState extends State<tdPopupScreen> {
  late List<String> localTodoList; // 로컬 To-Do 리스트
  late List<bool> completedStatus; // 완료 상태 관리
  int? editingIndex; // 현재 수정 중인 항목 인덱스
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    localTodoList = List.from(widget.todoList); // 초기 리스트 복사
    completedStatus = List.filled(localTodoList.length, false); // 초기 완료 상태 설정
  }

  void _addTodo() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        String newTodo = '새 할일 ${localTodoList.length + 1}';
        localTodoList.add(newTodo); //로컬 리스트에 추가
        completedStatus.add(false); // 새로운 항목 추가 시 완료 상태는 false
        widget.onAddTodo(newTodo); // 부모에 추가 이벤트 전달
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      localTodoList.removeAt(index); //로컬 리스트에서 삭제
      completedStatus.removeAt(index);
      widget.onDeleteTodo(index); // 부모에 삭제 이벤트 전달
    });
  }



  void _startEditing(int index) {
    setState(() {
      editingIndex = index;
      _textEditingController.text = localTodoList[index];
    });
  }

  void _saveEditing(int index) {
    setState(() {
      localTodoList[index] = _textEditingController.text;
      editingIndex = null;
      widget.onEditTodo(index, _textEditingController.text); // 부모에 수정 이벤트 전달
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        color: Colors.grey[850],
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 헤더
            const Text(
              'To-Do-List',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 리스트
            Expanded(
              child: ListView.builder(
                itemCount: localTodoList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          // 완료 상태 토글
                          completedStatus[index] = !completedStatus[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: completedStatus[index]
                              ? Colors.green[900] // 완료된 항목 색상
                              : const Color.fromRGBO(80, 255, 53, 1), // 기본 항목 색상
                        ),
                        child: ListTile(
                          leading: Icon(
                            completedStatus[index]
                                ? Icons.check_circle // 완료 시 체크 아이콘
                                : Icons.circle, // 기본 빈 원 아이콘
                            color: Colors.white,
                          ),
                          title: editingIndex == index
                              ? TextField(
                                  controller: _textEditingController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  onSubmitted: (_) => _saveEditing(index),
                                )
                              : GestureDetector(
                                  onTap: () => _startEditing(index),
                                  child: Text(
                                    localTodoList[index],
                                    style: TextStyle(
                                      color: completedStatus[index]
                                          ? Colors.black
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => _deleteTodo(index),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 추가 버튼
            ElevatedButton(
              onPressed: _addTodo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(80, 255, 53, 1),
              ),
              child: const Text('추가하기', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 16),

            // 닫기 버튼
            FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              backgroundColor: const Color.fromRGBO(80, 255, 53, 1),
              child: const Icon(Icons.close, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}*/