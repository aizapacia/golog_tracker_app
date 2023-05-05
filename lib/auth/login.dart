import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tracker/auth/auth_provider.dart';
import 'package:tracker/controller/api_controller.dart';
import 'package:tracker/widgets/loading.dart';
import 'package:tracker/widgets/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('img/bg/bg_login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('img/icon/logo_white.png'),
                  width: 150,
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 220.0,
                        height: 55.0,
                        child: TextFormField(
                          controller: phoneController,
                          textAlign: TextAlign.left,
                          decoration: const InputDecoration(
                            hintText: 'Enter phone number',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              const snackBar = SnackBar(
                                content: Text('Please input your number'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                            return null;
                          },
                        ),
                      ),

                      //Track BUtton
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.all(5.0),
                          fixedSize: const Size(80, 55),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                          side: const BorderSide(color: Colors.black, width: 1),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          String phoneNumber = phoneController.text.trim();
                          if (phoneNumber != '') {
                            checkPhoneNumber(phoneNumber);
                          } else {
                            toastMessage('Please input your phone number');
                          }
                        },
                        child: Text('Log in',
                            style: GoogleFonts.publicSans(
                              textStyle: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          )),
    );
  }

  toastMessage(String message) {
    showSnackBar(context, message);
  }

  checkPhoneNumber(phoneNumber) async {
    Loading().open(context);
    var data = await ApiController().getData('/checkUser/$phoneNumber', false);

    if (data['isUserValid'] == true) {
      AuthProvider.userPhone = phoneNumber;
      sendPhoneNumber(phoneNumber);
    } else {
      // ignore: use_build_context_synchronously
      Loading().close(context);
      toastMessage(data['message']);
    }
  }

  sendPhoneNumber(String userNum) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    await ap.signinWithPhone(context, userNum, false);
  }
}
