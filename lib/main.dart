import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tracker/auth/auth_provider.dart';
import 'package:tracker/login_cubit.dart';
import 'package:tracker/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (content) => LoginCubit(),
      child: Builder(builder: (context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: Builder(builder: (context) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Golog Tracker',
              routerConfig: AppRouter(context.read<LoginCubit>()).router,
              theme: ThemeData(
                useMaterial3: true,
                primaryColor: const Color(0xFFD71466),
                primarySwatch: Colors.grey,
                scaffoldBackgroundColor:
                    const Color.fromARGB(255, 237, 238, 251),
                fontFamily: GoogleFonts.publicSans().fontFamily,
                textTheme: const TextTheme(
                  displayLarge:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  labelLarge: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffD81466)),
                  labelMedium: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffD81466)),
                  titleLarge: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 75, 70, 92),
                  ),
                  titleMedium: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffD81466)),
                  bodySmall: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(51, 75, 70, 92),
                  ),
                  //this is for textfield input
                  bodyLarge: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 34, 33, 34)),
                  bodyMedium: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 75, 70, 92),
                  ),
                ),
              ),
              // home: const WelcomeScreen()
            );
          }),
        );
      }),
    );
  }
}
