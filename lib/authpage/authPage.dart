import 'package:flutter/material.dart';
import 'package:fureverhome/authentication/signup/sign_up.dart';
import 'package:fureverhome/users/guest_user.dart';
import 'package:fureverhome/users/registered_user.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 400,
            width: 350,
            color: Colors.blue,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, GuestUser.guestScreen);
                      },
                      child: _widgetAuthContainer(
                          title: 'Find a Pet.js',
                          description:
                              'Start your journey to finding a loving pet today! \n Browse through our listings and discover your perfect companion.'),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: _widgetAuthContainer(
                          title: 'Find a Home',
                          description:
                              'Looking for a loving home for your pet? List them here'),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

Widget _widgetAuthContainer(
    {required String title, required String description}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 350,
      width: 150,
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
          )
        ],
      ),
    ),
  );
}
