import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/auth/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String name = AuthProvider.userName;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.exit_to_app_rounded,
                      color: Color.fromARGB(255, 215, 20, 102),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Confirm Exit',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 215, 20, 102),
                      ),
                    )
                  ],
                ),
                content: Column(
                  children: const [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Do you want to close this application?',
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
                      child: const Text('Exit'),
                    ),
                  )),
                  CupertinoDialogAction(
                      child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 215, 20, 102)),
                      onPressed: () => Navigator.of(context).pop(false),
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
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 237, 238, 251),
          body: FutureBuilder(
              future: SessionManager().get('userName'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 221, 13, 93),
                    ),
                  );
                } else {
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.asset(
                          "img/bg/home.png",
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomLeft,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage('img/icon/logo.png'),
                              width: 120,
                            ),
                            Text(
                              'Hello $name,',
                              style: GoogleFonts.publicSans(
                                  textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff5D586C),
                              )),
                            ),
                            Text(
                              'Welcome Back',
                              style: GoogleFonts.publicSans(
                                  textStyle: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff5D586C),
                              )),
                            ),
                            const SizedBox(height: 20),
                            boxButton('Track Order', Icons.location_pin, 1,
                                'OrderTracker'),
                            const SizedBox(height: 15),
                            boxButton('Contact Support', Icons.headset_mic, 2,
                                'ContactSupport'),
                            const SizedBox(height: 130),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              })),
    );
  }

  boxButton(String name, var icon, int color, String nextPage) {
    return SizedBox(
      height: 150,
      width: 160,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: () => context.push(context.namedLocation(nextPage)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color == 1
                    ? const Color(0xFF0282FE)
                    : const Color(0xFF3132B2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 3.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.0), //BoxShadow
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 40.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: GoogleFonts.publicSans(
                  textStyle: const TextStyle(
                      color: Color(0xFF4B465C),
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}
