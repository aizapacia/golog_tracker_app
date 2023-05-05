import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tracker/login_cubit.dart';
import 'package:tracker/auth/auth_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    // ignore: use_build_context_synchronously
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final userSession = await SessionManager().containsKey("userName");
    if (ap.isSignedIn == true && userSession == true) {
      await AuthProvider().setUserValues();
      login();
    } else {
      logout();
    }
  }

  void login() {
    context.read<LoginCubit>().login();
    context.go(context.namedLocation('Home'));
  }

  void logout() {
    context.read<LoginCubit>().logout();
    context.go(context.namedLocation('Login'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage('img/icon/logo_only.png'),
            width: 150,
          ),
          SizedBox(height: 5),
          Text(
            'Golog Tracker',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 91, 80, 82),
            ),
          )
        ],
      )),
    );
  }
}
