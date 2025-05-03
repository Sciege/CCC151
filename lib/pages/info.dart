import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fureverhome/colors/appColors.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  static final String info_screen = '/info';

  @override
  Widget build(BuildContext context) {
    /// Responsive UI
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final double screenWidth = MediaQuery.of(context).size.width;
    //responsive text
    final double textScale =
        screenWidth / 360; // base size from common width of phone
    //responsive scale
    final iconSize = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'FureverHome',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.darkGray),
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColors.paleBeige,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: AppColors.gold.withOpacity(0.2),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Row(
                  children: [
                    //const Icon(Icons.info_outline, size: 16, color: AppColors.darkGray),
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
                    // IconButton(
                    //   padding: EdgeInsets.zero,
                    //   constraints: const BoxConstraints(),
                    //   icon: const Icon(Icons.close, size: 16, color: AppColors.darkGray),
                    //   onPressed: () {
                    //     //TODO
                    //     // Hide the disclaimer
                    //     // Implementation depends on your state management approach
                    //     // For example:
                    //     // setState(() {
                    //     //   showDisclaimer = false;
                    //     // });
                    //   },
                    // ),
                  ],
                ),
              ),
              Text('Meet The Team',
                  style: TextStyle(
                      fontSize: height * 0.051, // Making it responsive
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGray)),
              Container(
                width: width * 0.75, // Making it responsive
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.creamWhite,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2), blurRadius: 5)
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
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('CHESLER JOHN HAMILI',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16 * textScale,
                                          color: AppColors.darkGray)),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        child: Icon(
                                          Icons.facebook,
                                          color: AppColors.darkGray,
                                          size: 0.075 * iconSize,
                                        ),
                                        onTap: (){
                                          launchUrl(Uri.parse('https://www.facebook.com/cheslerjohn'),mode: LaunchMode.inAppBrowserView);
                                        },
                                      ),
                                      GestureDetector(
                                        child: SvgPicture.asset(
                                          'assets/github.svg',
                                          color: AppColors.darkGray,
                                          height: 0.075 * iconSize,
                                          width: 0.075 * iconSize,
                                        ),
                                        onTap: (){launchUrl(Uri.parse('https://github.com/Sciege'),mode: LaunchMode.inAppBrowserView);},
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                'Developer',
                                style: TextStyle(
                                    color: AppColors.darkGray,
                                    fontSize: 12 * textScale),
                              ),
                              Text(
                                'BSIT 2D',
                                style: TextStyle(
                                    color: AppColors.darkBlueGray,
                                    fontSize: 12 * textScale),
                              ),
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
      ),
    );
  }
}
