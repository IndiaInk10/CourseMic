import 'package:capston/chatAdditional/importent_msg_quiz/pages/important_message_page.dart';
import 'package:capston/chat/pages/chat_page.dart';
import 'package:capston/chatAdditional/file_share/widget/file_and_image_upload.dart';
import 'package:capston/chatAdditional/participation_viewer/widget/participation.dart';
import 'package:capston/chatAdditional/todo_list/pages/todo_list_page.dart';
import 'package:capston/widgets/RoundButtonStyle.dart';
import 'package:flutter/material.dart';

class ChatAdditionalFunc extends StatefulWidget {
  final String roomID;
  final ChatPageState chatPageState;

  const ChatAdditionalFunc(
      {Key? key, required this.roomID, required this.chatPageState})
      : super(key: key);

  @override
  _ChatAdditionalFuncState createState() => _ChatAdditionalFuncState();
}

class _ChatAdditionalFuncState extends State<ChatAdditionalFunc> {
  String currentFunction = '';
  Widget? dynamicWidget;
  double minHeight = 50;
  double maxHeight = 280;

  void setFunction(String function) {
    //setState로 미리보기 창 제어. 각 위젯 명은 가칭이니, 변경 가능
    setState(() {
      currentFunction = function;
      switch (function) {
        case "자료 조회 or 보내기":
          dynamicWidget = File_And_Image_Picker(
            roomID: widget.roomID,
            chatDataParent: widget.chatPageState,
          );
          break;
        case "Todo리스트 조회":
          dynamicWidget = ToDoListPage(
            roomID: widget.roomID,
            chatPageState: widget.chatPageState,
            bMini: true,
          );
          break;
        case "중요한 메세지? 모아보기":
          dynamicWidget = SimpleImportantMessage(
            roomID: widget.roomID,
            chatPageState: widget.chatPageState,
          );
          break;
        case "참여도 점수 보기":
          dynamicWidget = Participation(
            chatDataParent: widget.chatPageState,
          );
          break;
        default:
          dynamicWidget = null;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dynamicWidget == null ? minHeight : maxHeight,
      color: Colors.white,
      child: Center(
        child: Column(
          //버튼 리스트 칼럼
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: ButtonBar(
                buttonPadding: EdgeInsets.zero,
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: ElevatedButton(
                      onPressed: () {
                        setFunction('자료 조회 or 보내기');
                      },
                      style: buttonStyle,
                      child: const Text('자료 공유'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setFunction('Todo리스트 조회');
                    },
                    style: buttonStyle,
                    child: const Text('할 일 목록'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setFunction('중요한 메세지? 모아보기');
                    },
                    style: buttonStyle,
                    child: const Text('중요메세지'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setFunction('참여도 점수 보기');
                    },
                    style: buttonStyle,
                    child: const Text('참여도'),
                  ),
                ],
              ),
            ),
            if (dynamicWidget != null)
              Expanded(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: dynamicWidget!,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DataWidget extends StatelessWidget {
  const DataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Data Widget');
  }
}
