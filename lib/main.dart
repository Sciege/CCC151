import 'package:flutter/material.dart';
import 'package:fureverhome/pages/info.dart';
import 'package:fureverhome/users/guest_user.dart';
import 'package:fureverhome/users/registered_user.dart';
import 'authpage/authPage.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
      '/' : (context)=> AuthPage(),
        GuestUser.guestScreen: (context) => GuestUser(),
        RegisteredUser.registered_user_screen: (context) => RegisteredUser(),
        Info.info_screen: (context) => Info()
      },
    );
  }
}
