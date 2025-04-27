import 'package:flutter/material.dart';
import 'package:fureverhome/colors/appColors.dart';
import '../services/auth_services.dart';
import '../signup/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPass = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.creamWhite,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: AppColors.darkGray),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      body: Container(
        color: AppColors.paleBeige,
        child: Column(
          children: [
            // Centered scrollable content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      const Icon(
                        Icons.pets,
                        size: 80,
                        color: AppColors.darkBlueGray,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGray,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Log in to your account',
                        style: TextStyle(
                          color: AppColors.darkGray.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(27),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkBlueGray.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: AppColors.darkGray.withOpacity(0.5),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: AppColors.mediumBlueGray,
                              size: 22,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(27),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkBlueGray.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: !showPass,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: AppColors.darkGray.withOpacity(0.5),
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.mediumBlueGray,
                              size: 22,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => showPass = !showPass),
                              icon: Icon(
                                showPass
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.mediumBlueGray,
                                size: 22,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),

                      // TODO: Implement forgot password
                      // Forgot password
                      /*
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            /// handle forgot password case
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.darkBlueGray,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      */

                      const SizedBox(height: 16),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            await AuthService().logIn(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkBlueGray,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                          ),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'By logging in, you agree to our Terms of Service and Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGray.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom sign-up link
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: AppColors.darkGray.withOpacity(0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (_) => SignUp()),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: AppColors.darkBlueGray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
