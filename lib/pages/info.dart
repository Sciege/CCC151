import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  static final String info_screen = '/info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Meet The Team',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            Container(
              width: 310,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Transform.scale(
                      // To zoom the image lol
                      scale: 1.1,
                      child: Image.asset(
                        'assets/my_picture.jpg',
                        height: 300, // Adjusted size
                        width: double.infinity, // Ensures full width
                        fit: BoxFit.cover, // Maintains aspect ratio
                        alignment: Alignment(0, -0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('CHESLER JOHN HAMILI',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.facebook),
                                    Image.asset('assets/mdi_github.png'),
                                  ],
                                )
                              ],
                            ),
                            Text('Full Stack Developer'),
                            Text('BSIT 2DA'),
                          ],
                        ),
                      ),
                    ],
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
