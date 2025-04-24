import 'package:flutter/material.dart';
import 'package:fureverhome/authentication/signup/sign_up.dart';
import 'package:fureverhome/users/guest_user.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Furever Home',style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.normal,
        ),),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 350,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15), // Increased radius for smoother edges
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAuthContainer(
                icon: Icon(Icons.pets_sharp,size: 50),
                context: context,
                title: 'Find a Pet',
                description: 'Start your journey to finding a loving pet today! Browse through our listings and discover your perfect companion.',
                onTap: () {
                  Navigator.pushNamed(context, GuestUser.guestScreen);
                },
              ),
              _buildAuthContainer(
                icon: Icon(Icons.home,size: 50),
                context: context,
                title: 'Find a Home',
                description: 'Looking for a loving home for your pet? List them here.',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthContainer({
    required Icon icon,
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onTap, // just used for action
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 350,
        width: 150,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), // Increased radius for smoother edges
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10, // Increased blur radius for softer shadow
              offset: const Offset(0, 5), // Increased offset for better shadow effect
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias, // Ensure proper clipping of rounded corners
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon, // use icon instantly since it is declared Icon
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
