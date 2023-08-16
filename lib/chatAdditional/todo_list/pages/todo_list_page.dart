import 'package:capston/chat/pages/chat_page.dart';
import 'package:flutter/material.dart';

import 'package:capston/chatAdditional/todo_list/widgets/todo_list.dart';

import 'package:capston/utils/palette.dart';

class ToDoListPage extends StatefulWidget {
  final roomID;
  final ChatPageState chatPageState;
  final bool bMini;
  final ToDoListPageState? todoPageState;

  const ToDoListPage(
      {super.key,
      required this.roomID,
      required this.chatPageState,
      this.bMini = false,
      this.todoPageState});

  @override
  State<ToDoListPage> createState() => ToDoListPageState();
}

// 추후 수정
class ToDoListPageState extends State<ToDoListPage> {
  bool bMyTodo = false;

  @override
  void initState() {
    super.initState();
  }

  // ToDoListPage + ToDoList > ToDoListPage
  @override
  Widget build(BuildContext context) {
    return widget.bMini
        ? Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.lightGray,
                      offset: Offset(0.0, 5.0), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 14.0, top: 4.0, bottom: 12.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ToDoListPage(
                            roomID: widget.roomID,
                            chatPageState: widget.chatPageState,
                            todoPageState: this,
                          ),
                        ),
                      ),
                      child: const Text("+ 할 일 목록 크게 보기",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Palette.brightBlue)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ToDoList(
                  roomID: widget.roomID,
                  chatDataState: widget.chatPageState,
                  bMini: widget.bMini,
                  todoDataParent: widget.todoPageState ?? this,
                ),
              ),
            ],
          )
        : ToDoList(
            roomID: widget.roomID,
            chatDataState: widget.chatPageState,
            bMini: widget.bMini,
            todoDataParent: widget.todoPageState ?? this,
          );
  }

  toggleMyTodo() {
    setState(() {
      bMyTodo = !bMyTodo;
    });
  }
}
