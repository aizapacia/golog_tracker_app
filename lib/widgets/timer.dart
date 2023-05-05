import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  // ignore: unused_field
  Timer? _timer;
  int remainingSeconds = 1;
  final time = '00.00'.obs;

  @override
  void onReady() {
    _startTimer(30);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
      } else {
        int seconds = remainingSeconds;
        time.value = seconds.toString().padLeft(2, "0");
        remainingSeconds--;
      }
    });
  }
}
