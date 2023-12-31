import 'package:chat_application/screen/sigup_screen.dart';
import 'package:chat_application/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToSignup() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SlideTransition(
            position: _animation,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(20),
              height: 400,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: GoogleFonts.openSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        FirebaseServices().signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Success')));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      overlayColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: navigateToSignup,
                    child: Text('Don\'t have an account? Sign up'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
