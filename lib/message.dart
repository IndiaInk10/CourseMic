import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatting/chat_screen.dart';

class RoomList extends StatefulWidget {
  RoomList({Key? key}) : super(key: key);
  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> loadingdata() async {
    final authentication = FirebaseAuth.instance;

    final user = authentication.currentUser;
    print(user!.uid);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 최상위 컬렉션에서 하위 컬렉션까지 한 번에 지정하는 변수
    DocumentReference docRef = firestore.collection('exuser').doc(user.uid);

    // 문서의 데이터를 가져옵니다.
    DocumentSnapshot docSnapshot = await docRef.get();

    // 문서 내부의 사람리스트 필드를 가져옵니다.
    List<dynamic> roomList1 = docSnapshot.get('톡방리스트');
    print("!");

    print(roomList1.length);
    roomList = [];
    for (var i in roomList1) {
      DocumentReference roomRef = firestore.collection('exchat').doc(i);
      DocumentSnapshot roomnameSnapshot = await roomRef.get();
      String roomname = roomnameSnapshot.get('톡방이름');

      final chatDocsSnapshot = await FirebaseFirestore.instance
          .collection('exchat')
          .doc(i)
          .collection('message')
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (chatDocsSnapshot.docs.isNotEmpty) {
        final lastMessage = chatDocsSnapshot.docs[0]['text'];

        roomList.add([
          roomname,
          i,
          lastMessage,
        ]);
      } else {
        roomList.add([
          roomname,
          i,
          '',
        ]);
      }
    }
    roomList1 = [];
  }

  late List<List<dynamic>> roomList; //톡방 이름, UID, 마지막 메시지 저장
  Widget room(String a, String b, String c) {
    //UID는 onTap에서 톡방을 불러오기 위해 사용
    //톡방을 리스트를 보여주는 함수
    return InkWell(
      onTap: () {
        print("해당 톡방이 클릭됬음 $b");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatScreen(
                roomname: b,
                roomname1: b,
              );
            },
          ),
        );
        ChatScreen(
          roomname: b,
          roomname1: b,
        );
      },
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.only(top: 8), //톡방간 간격
          child: Row(children: [
            Image.asset(
              //톡방별 대표 이미지 개개인 프사나 해당 톡방에서의 역할 표시하면 좋을듯
              "assets/image/logo.png",
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SizedBox(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, //글자 왼쪽 정렬
                    children: [
                      Text(
                        a,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                        // 톡방 제목은 굵게
                      ),
                      Text(c),
                    ]),
              ),
            ),
          ]),
        ),
      ),
    ); // SizedBox를 제거하고 Text 위젯만 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadingdata(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 중일 때 표시될 위젯
          } else {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}')); // 오류 발생 시 표시될 위젯
            } else {
              return ListView(
                children: [
                  for (var data in roomList)
                    room(data[0], data[1], data[2]), // 자신이 속한 톡방의 갯수만큼 반복
                ],
              );
            }
          }
        },
      ),
    );
  }
}
