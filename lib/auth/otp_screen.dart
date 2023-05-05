// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tracker/widgets/utils.dart';

import '../controller/api_controller.dart';
import '../login_cubit.dart';
import 'auth_provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;
  bool isLoading = false;
  String userPhone = AuthProvider.userPhone;
  final controller = ApiController();
  var sessionManager = SessionManager();
  final primaryColor = const Color.fromARGB(255, 215, 20, 102);
  final normalStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color.fromARGB(255, 93, 92, 92));

  //TIMER VARIABLE
  // ignore: unused_field
  Timer? _timer;
  int remainingSeconds = 30;

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 215, 20, 102),
                  ),
                ),
                content: Column(
                  children: const [
                    SizedBox(height: 10),
                    Text(
                      'Are you sure you want to cancel?',
                    )
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                      child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 215, 20, 102),
                          foregroundColor: Colors.white),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes'),
                    ),
                  )),
                  CupertinoDialogAction(
                      child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 215, 20, 102)),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No'),
                    ),
                  )),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: nextPage(isLoading),
    ));
  }

  //check in db if user phone number exist
  verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      // verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () async {
        //check if user exist in db
        if (_timer != null) {
          _timer!.cancel();
        }
        var data = {'phoneNumber': userPhone};
        var value = await controller.getToken('/gettoken', data);

        if (value != null) {
          ap.setSignIn().then((value) {
            isLoading = false;
            context.read<LoginCubit>().login();
            context.go(context.namedLocation('Home'));
          });
        } else {
          setState(() {
            isLoading = false;
          });
          var message = 'Something went wrong. Try again later.';
          showSnackBar(context, message);
          context.go(context.namedLocation('Login'));
        }
      },
    );
  }

  //firebase send otp
  sendPhoneNumber(String userNum) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.signinWithPhone(context, userNum, true);
  }

  //timer
  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          remainingSeconds = 30;
        });
      }
    });
  }

  //layout
  nextPage(bool isLoading) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg/bg_login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('img/icon/logo_white.png'),
              width: 150,
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 15.0, top: 15.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Verify Phone',
                        style: GoogleFonts.publicSans(
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color.fromARGB(255, 215, 20, 102)),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Code is sent to ',
                            style:
                                GoogleFonts.publicSans(textStyle: normalStyle),
                          ),
                          Text(
                            userPhone,
                            style:
                                GoogleFonts.publicSans(textStyle: normalStyle),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Pinput(
                        enabled: isLoading == false ? true : false,
                        length: 6,
                        showCursor: true,
                        defaultPinTheme: PinTheme(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: primaryColor,
                              ),
                            ),
                            textStyle: GoogleFonts.publicSans(
                                textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ))),
                        onCompleted: (value) {
                          otpCode = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            if (otpCode != null) {
                              verifyOtp(context, otpCode!);
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              showSnackBar(context, 'Enter 6 digit code');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: isLoading == false
                              ? const Text('Verify')
                              : const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Didn't receive any code?",
                        style: GoogleFonts.publicSans(
                          textStyle: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 93, 92, 92),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (remainingSeconds == 30) ...[
                        GestureDetector(
                          onTap: () async {
                            String number = userPhone;
                            sendPhoneNumber(number);
                            // ignore: unnecessary_null_comparison
                            showSnackBar(context, 'OTP sent successfully');
                            _startTimer();
                          },
                          child: Text(
                            "Resend New Code",
                            style: GoogleFonts.publicSans(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 215, 20, 102),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          ' Resend in ${remainingSeconds}s',
                          style: GoogleFonts.publicSans(
                            textStyle: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 215, 20, 102),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
