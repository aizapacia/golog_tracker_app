//import 'package:flutter/material.dart';

class ErrorWidgets {
  static void showErrorDialog({
    String? title,
    String? description,
  }) {
    // Get.dialog(
    //   Dialog(
    //     child: Container(
    //       height: 220,
    //       padding: const EdgeInsets.all(20),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Text(
    //             title ?? 'Error',
    //             style: Get.textTheme.headlineMedium,
    //           ),
    //           const SizedBox(height: 15),
    //           Text(
    //             description ?? 'Something went wrong',
    //             style: Get.textTheme.headlineSmall,
    //           ),
    //           const SizedBox(height: 15),
    //           ElevatedButton(
    //               onPressed: () {
    //                 Get.back();
    //               },
    //               child: const Text('Okay'))
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  //SHOW LOADING
  static void showLoading([String? message]) {
    // Get.dialog(Dialog(
    //   elevation: 0,
    //   backgroundColor: Colors.white,
    //   child: Padding(
    //     padding: const EdgeInsets.all(20.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         const CircularProgressIndicator(),
    //         Text(message ?? 'Loading...'),
    //       ],
    //     ),
    //   ),
    // ));
  }

  //HIDE LOADING
  static void hideLoading() {
    //if (Get.isDialogOpen!) Get.back();
  }
}
