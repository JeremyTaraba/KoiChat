import 'package:flutter/material.dart';
import 'package:our_chat/screens/welcome_screen.dart';
import 'package:our_chat/screens/login_screen.dart';
import 'package:our_chat/screens/registration_screen.dart';
import 'package:our_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark().copyWith(
          primary: Colors.orange,
          secondary: Colors.red,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
