import 'package:saiphappfinal/Screens/Quiz/screens/quiz_screen/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saiphappfinal/Screens/Quiz/screens/result_screen/result_screen.dart';
import 'package:saiphappfinal/Screens/Quiz/screens/welcome_screen.dart';
import 'package:saiphappfinal/Screens/Quiz/utils/bindings_app.dart';

import 'controller/quiz_controller.dart';

class QuizgameScreen extends StatefulWidget {
  @override
  _QuizgameScreenState createState() => _QuizgameScreenState();
}

class _QuizgameScreenState extends State<QuizgameScreen> {
  final QuizController quizController = Get.put(QuizController());
  @override
  Widget build(BuildContext context) {
    return WelcomeScreen();
  }
}
