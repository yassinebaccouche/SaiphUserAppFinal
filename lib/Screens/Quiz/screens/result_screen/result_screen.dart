import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saiphappfinal/Screens/Quiz/controller/quiz_controller.dart';
import 'package:saiphappfinal/Screens/Quiz/screens/welcome_screen.dart';
import 'package:saiphappfinal/Screens/Quiz/widgets/custom_button.dart';
import 'package:saiphappfinal/Models/user.dart'; // import your User model

import 'package:saiphappfinal/providers/user_provider.dart';
import 'package:saiphappfinal/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: SizedBox(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                "assets/images/close_icon.svg",
                width: 25,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: GetBuilder<QuizController>(
              init: Get.find<QuizController>(),
              builder: (controller) => Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 2,
                    colors: [
                      Color(0xff1331C4).withOpacity(0.1),
                      Color(0xff1331C4).withOpacity(0.2),
                      Color(0xff1331C4).withOpacity(0.3),
                      Color(0xff1331C4).withOpacity(0.4),
                      Color(0xff1331C4).withOpacity(0.5)
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Félicitations',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Color(0xFF273085),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      controller.name,
                      style: Theme.of(context).textTheme.headline3!.copyWith(),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Votre Score est',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Color(0xFF273085),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      '${controller.scoreResult} /10',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: Color(0xFF273085),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FloatingActionButton.extended(
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      backgroundColor: Color(0xFF273085),
                      onPressed: () {
                        user?.FullScore = (int.parse(user?.FullScore ?? '0') + controller.scoreResult).toString();
                        controller.startAgain();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WelcomeScreen(),
                          ),
                        );
                      },
                      label: Text(
                        'Recommencer',
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
