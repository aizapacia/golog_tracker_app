import 'package:flutter/material.dart';

class Loading {
  open(context) {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          )),
    );
  }

  close(context) {
    Navigator.pop(context);
  }
}
