import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/info.dart';

class RegisteredUser extends StatefulWidget {
  const RegisteredUser({super.key});

  static final registered_user_screen = '/registered_user';

  @override
  State<RegisteredUser> createState() => _RegisteredUserState();
}

String searchQuery = '';

class _RegisteredUserState extends State<RegisteredUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                // child: TextField(
                //   onChanged: (value) {
                //     setState(() {
                //       searchQuery = value;
                //     });
                //   },
                //   decoration: InputDecoration(
                //     hintText: 'Search',
                //     hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                //     prefixIcon: Icon(Icons.search),
                //     contentPadding: EdgeInsets.symmetric(),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //   ),
                //   textAlignVertical: TextAlignVertical.center,
                // ),
              ),
            ),
            //SizedBox(width: 10),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Info.info_screen);
              },
              icon: Icon(
                Icons.info_outline,
                size: 35,
              ),
            ),
            // backgroundColor: Colors.white,
            // elevation: 5,
            // systemOverlayStyle: SystemUiOverlayStyle(
            // statusBarColor: Colors.transparent,
            // statusBarIconBrightness: Brightness.dark,
            // ),
          ],
        ),
      ),
      body: Center(),
    );
  }
}
