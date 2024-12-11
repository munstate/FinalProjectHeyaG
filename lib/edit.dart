import 'package:flutter/material.dart';

class EditQuotePopup extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSave;

  const EditQuotePopup({
    Key? key,
    required this.controller,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("문구 수정"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "오늘 걸어야 내일 뛰지 않는다."),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSave(controller.text);
            Navigator.pop(context);
          },
          child: const Text("저장"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("취소"),
        ),
      ],
    );
  }
}