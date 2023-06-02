import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:our_chat/components/rounded_button.dart';
import 'package:our_chat/screens/registration_screen.dart';
import 'package:our_chat/screens/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = '/';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // late AnimationController colorController;
  // late Animation colorAnimation;
  //
  // late AnimationController buttonController;
  // late Animation buttonAnimation;

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    // colorController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 1),
    // );
    // colorAnimation = ColorTween(begin: Colors.black, end: Colors.white)
    //     .animate(colorController);
    // colorAnimation.addListener(() {
    //   setState(() {});
    // });
    // colorController.forward();

    // buttonController = AnimationController(
    //   vsync: this,
    //   duration: Duration(seconds: 1),
    // );
    // buttonAnimation =
    //     CurvedAnimation(parent: buttonController, curve: Curves.ease);
    //
    // buttonController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 130,
                    child: Image.asset('images/koi.png'),
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  pause: Duration(seconds: 3),
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Koi Chat',
                      speed: Duration(milliseconds: 350),
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RoundedButton(
                  text: 'Log In',
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.id);
                  },
                ),
                RoundedButton(
                  text: 'Register',
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
