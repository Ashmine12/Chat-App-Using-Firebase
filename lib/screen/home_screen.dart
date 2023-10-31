import 'package:chat_application/model/user_model.dart';
import 'package:chat_application/screen/chat_screen.dart';
import 'package:chat_application/screen/login_screen.dart';
import 'package:chat_application/services/firebase_service.dart';
import 'package:chat_application/services/share_helper.dart';
import 'package:chat_application/widgets/chat_card.dart';
import 'package:chat_application/widgets/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Method to fetch user data
  Future<void> _fetchUserData() async {
    List<UserModel>? userList = await _firebaseServices
        .fetchUserData(FirebaseAuth.instance.currentUser!.uid);
    if (userList != null) {
      setState(() {
        users = userList;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
              await SharedPrefHelper().clearSharedPreferences();
            },
            icon: Icon(
              color: Colors.red,
              Icons.logout,
            ),
          )
        ],
        backgroundColor: Colors.black,
        title: Text(
          'Chet-Chat',
          style: GoogleFonts.akronim(
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _fetchUserData();
          });
        },
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return Column(
              children: [
                ChatCard(
                  name: user.name ?? '',
                  imgUrl: user.image ?? '',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          receiverUserId: user.uid ?? "",
                          senderUserId: FirebaseAuth.instance.currentUser!.uid,
                          imgUrl: user.image ?? '',
                          name: user.name ?? '',
                        ),
                      ),
                    );
                  },
                ),
                Gap(
                  height: 20,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
