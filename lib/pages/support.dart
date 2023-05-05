import 'package:flutter/material.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5FF),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "img/bg/support.png",
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomLeft,
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                        color: const Color(0xFFD71466),
                      ),
                    )),
                const SizedBox(height: 40),
                const Image(
                  image: AssetImage('img/icon/logo.png'),
                  width: 150,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Contact Support',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color(0xFF5D586C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  'You may contact us to our \n hotline',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF5D586C),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  '0172881735',
                  style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFFD71365),
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
