import 'package:chat_application/screen/home_screen.dart';
import 'package:chat_application/screen/login_screen.dart';
import 'package:chat_application/services/share_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget initialScreen = LoginScreen();
  @override
  void initState() {
    super.initState();
    checkLoggedInStatus();
  }

  void checkLoggedInStatus() async {
    var isLoggedIn = await SharedPrefHelper.isLoggedIn();
    if (isLoggedIn) {
      setState(() {
        initialScreen = const HomeScreen();
      });
    } else {
      setState(() {
        initialScreen = const LoginScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return initialScreen != null
        ? initialScreen
        : Center(
            child:
                CircularProgressIndicator(), // You can display a loading indicator while checking login status
          );
  }
}
