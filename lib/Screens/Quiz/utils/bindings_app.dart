import 'package:get/get.dart';
import 'package:saiphappfinal/Screens/Quiz/controller/quiz_controller.dart';

class BilndingsApp implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => QuizController());
  }
}
