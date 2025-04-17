
import 'package:flutter/material.dart';

import '../login/log_in.dart';
import '../services/auth_services.dart';


class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showPass = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register Account',
                    style: TextStyle(fontSize: 40),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: showPass ? false : true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          icon: Icon(showPass
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          await AuthService().signUp(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context);
                        },
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1,
                                color: Colors.black,
                                style: BorderStyle.solid)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already Have Account?'),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text('Log in'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}