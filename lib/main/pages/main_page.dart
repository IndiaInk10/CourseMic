import 'package:capston/utils/notification.dart';
import 'package:capston/utils/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capston/chat/pages/chat_list_page.dart';
import 'package:capston/profile/page/profile_page.dart';

class MainPage extends StatefulWidget {
  final String currentUserID;
  const MainPage({super.key, required this.currentUserID});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    FCMLocalNotification.getMyDeviceToken().then(
      (value) {
        FirebaseFirestore.instance
            .collection('user')
            .doc(widget.currentUserID)
            .update({'deviceToken': value});
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: [
        const ChatListPage(),
        ProfilePage(
          userID: widget.currentUserID,
          bMyProfile: true,
          bChild: false,
        ),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 0.5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Palette.lightGray,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                  _currentIndex == 0
                      ? Icons.messenger_rounded
                      : Icons.messenger_outline_rounded,
                  color: Palette.pastelPurple),
              label: '채팅방',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  _currentIndex == 1
                      ? Icons.account_circle_rounded
                      : Icons.account_circle_outlined,
                  color: Palette.pastelPurple),
              label: '마이페이지',
            ),
          ],
        ),
      ),
    );
  }
}
