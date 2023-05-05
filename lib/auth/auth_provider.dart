import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/controller/api_controller.dart';
import 'package:tracker/widgets/utils.dart';

import '../widgets/loading.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  dynamic verId;
  dynamic resendToken;
  static String userPhone = '';
  static String userName = '';
  static String userId = '';
  static String userProfile = '';
  static String userAddress = '';
  static String token = '';
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("is_signedin") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

  //Signin
  dynamic signinWithPhone(
      BuildContext context, String userNum, bool reSend) async {
    try {
      var phoneNumber = '+$userNum';
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        //ON VERIFICATION IS COMPLETED
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.currentUser!.reload();
          if (firebaseAuth.currentUser == null) {
            await firebaseAuth.signInWithCredential(credential);
          }
        },

        //WHEN VERIFICATION FAILED
        verificationFailed: (FirebaseAuthException e) {
          Loading().close(context);
          if (e.code == 'invalid-phone-number') {
            showSnackBar(
                context, 'Invalid phone number format (ex. 60xxxxxxxxx)');
          } else if (e.code == 'too-many-requests') {
            //MAKE THIS DIALOG BOX WITH IMAGE
            showSnackBar(context, e.message.toString());
          } else {
            showSnackBar(context, e.message.toString());
          }
        },

        //ON CODE SENT
        codeSent: (String verificationId, int? forceResendingToken) async {
          verId = verificationId;
          resendToken = forceResendingToken;

          if (reSend == false) {
            Loading().close(context);
            context.go(context.namedLocation('Verify'));
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // showSnackBar(context,
          //     'Your OTP code has expired. Please resend code to continue.');
        },
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  //OTP
  void verifyOtp({
    required BuildContext context,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: userOtp,
      );
      //get user Value
      User? user = (await firebaseAuth.signInWithCredential(creds)).user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        onSuccess();
      }

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //SIGNOUT
  Future userSignOut() async {
    var deleteToken = ApiController().logout();
    if (deleteToken != null) {
      await firebaseAuth.signOut();
      await SessionManager().destroy();
      _isSignedIn = false;
      notifyListeners();
    }
  }

  //SAVE SESSION
  Future setUserValues() async {
    var session = SessionManager();
    var userName = await session.get('userName');
    var userId = await session.get('userID');
    var userAddress = await session.get('userAddress');
    var userPhone = await session.get('userPhoneD');
    var userProfile = await session.get('userProfile');
    var token = await session.get('token');

    AuthProvider.userName = userName.toString();
    AuthProvider.userId = userId.toString();
    AuthProvider.userProfile = userProfile.toString();
    AuthProvider.userAddress = userAddress.toString();
    AuthProvider.userPhone = userPhone.toString();
    AuthProvider.token = token.toString();
  }
}
