import 'package:flutter/material.dart';
import 'package:fureverhome/colors/appColors.dart';
import '../login/log_in.dart';
import '../services/auth_services.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

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
      // Remove AppBar to use a floating back button
      body: Stack(
        children: [
          // Main content
          Container(
            color: AppColors.paleBeige,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                            'Register Account',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGray,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Join us to find your new best friend',
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
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                                  onPressed: () {
                                    setState(() {
                                      showPass = !showPass;
                                    });
                                  },
                                  icon: Icon(
                                    showPass
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.mediumBlueGray,
                                    size: 22,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Sign up button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () async {
                                await AuthService().signUp(
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
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Terms and Privacy Policy
                          Text(
                            'By signing up, you agree to our Terms of Service and Privacy Policy',
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

                // Bottom login link
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already Have Account?',
                        style: TextStyle(
                          color: AppColors.darkGray.withOpacity(0.7),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        ),
                        child: const Text(
                          'Log in',
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

          // Floating back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: FloatingActionButton.small(
              backgroundColor: Colors.white70,
              elevation: 0,
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back, color: AppColors.darkGray),
            ),
          ),
        ],
      ),
    );
  }
}
