import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fureverhome/authentication/signup/sign_up.dart';
import 'package:fureverhome/users/guest_user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../colors/appColors.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    //responsive text
    final double textScale =
        screenWidth / 360; // base size from common width of phone
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        title: const Text(
          'Furever Home',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.darkGray,
          ),
        ),
      ),
      body: Container(
        color: AppColors.paleBeige,
        child: Column(
          children: [
            // Disclaimer shown at the top always
            Container(
              width: double.infinity,
              color: AppColors.gold.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 12 * textScale,
                        ),
                        children: [
                          TextSpan(
                              text: 'Disclaimer:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(
                              text:
                              ' This is beta version. Report a problem via '),
                          TextSpan(
                            text: 'feedback form',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 12 * textScale,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Open Google Forms feedback form in browser
                                launchUrl(
                                  Uri.parse(
                                      'https://forms.gle/Piyb7XTnhpGAdHbo9'),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                          ),
                          TextSpan(text: '!')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double containerWidth = constraints.maxWidth > 600
                        ? 500
                        : constraints.maxWidth * 0.9;
                    double containerHeight = constraints.maxHeight * 0.75;
                    bool isWideScreen = constraints.maxWidth > 600;

                    return Container(
                      height: containerHeight,
                      width: containerWidth,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.creamWhite,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkBlueGray.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: isWideScreen
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildAuthContainers(context, isWideScreen),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildAuthContainers(context, isWideScreen),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAuthContainers(BuildContext context, bool isWideScreen) {
    return [
      _buildAuthContainer(
        icon: Icons.pets_sharp,
        title: 'Find a Pet',
        description:
        'Start your journey to finding a loving pet today! Browse through our listings and discover your perfect companion.',
        onTap: () {
          Navigator.pushNamed(context, GuestUser.guestScreen);
        },
        isWideScreen: isWideScreen,
        cardColor: AppColors.darkBlueGray,
        context: context,
      ),
      _buildAuthContainer(
        icon: Icons.home,
        title: 'Find a Home',
        description: 'Looking for a loving home for your pet? List them here.',
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUp()));
        },
        isWideScreen: isWideScreen,
        cardColor: AppColors.mediumBlueGray,
        context: context,
      ),
    ];
  }

  Widget _buildAuthContainer({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required bool isWideScreen,
    required BuildContext context,
    required Color cardColor,
  }) {
    double width = isWideScreen
        ? MediaQuery.of(context).size.width * 0.35
        : MediaQuery.of(context).size.width * 0.8;

    double height = isWideScreen
        ? MediaQuery.of(context).size.height * 0.4
        : MediaQuery.of(context).size.height * 0.25;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      splashColor: AppColors.gold.withOpacity(0.3),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGray.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isWideScreen ? 60 : 50, color: AppColors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isWideScreen ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isWideScreen ? 16 : 14,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}