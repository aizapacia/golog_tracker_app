import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showDialogBox(
  BuildContext context,
  Widget title,
  String description,
  String buttonName,
  Function onPressed,
) {
  showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => Dialog(
            elevation: 0,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  title,
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(115, 40),
                            backgroundColor:
                                const Color.fromARGB(255, 215, 20, 102),
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.publicSans(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        onPressed: () => onPressed(),
                        child: Text(buttonName),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(115, 40),
                            backgroundColor: Colors.white,
                            foregroundColor:
                                const Color.fromARGB(255, 215, 20, 102),
                            textStyle: GoogleFonts.publicSans(
                                textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                        onPressed: () {
                          Navigator.pop(context, 'Cancel');
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ));
}
