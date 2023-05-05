import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget orderDriver(data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Driver',
        style: TextStyle(
          color: Color.fromARGB(255, 215, 20, 102),
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      //IF NO DRIVER
      if (data['orderLog']['status'] == 1 ||
          data['orderLog']['status'] == 10) ...[
        Row(
          children: const [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('img/icon/driver.png'),
            ),
            SizedBox(width: 20),
            Text(
              'Waiting for Driver to be Assign',
              style: TextStyle(
                color: Color.fromARGB(248, 37, 39, 51),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ] else if (data['orderLog']['status'] == 6 ||
          data['orderLog']['status'] == 4 ||
          data['orderLog']['status'] == 3) ...[
        if (data['driver'] != null) ...[
          Center(
            child: Text(
              data['driver']['name'] ?? '-',
              style: GoogleFonts.publicSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              getImage(data['img']['driver']),
              Column(
                children: [
                  Image(
                    image: setVihicle(data['orderLog']['trans']),
                    width: 50,
                  ),
                  const Text(
                    'VEHICLE',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 158, 158, 162)),
                  )
                ],
              ),
              Column(
                children: [
                  Text(data['driver']['plate_num'] ?? '-'),
                  const Text(
                    'PLATE NUMBER',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 158, 158, 162)),
                  )
                ],
              )
            ],
          ),
        ] else ...[
          Center(
            child: Text(
              'No driver information',
              style: GoogleFonts.publicSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('img/icon/driver.png'),
          )
        ]
        //DRIVER OTHER INFO
      ],

      const SizedBox(height: 10),
    ],
  );
}

setVihicle(String vType) {
  String imgPath = 'img/vehicle/';
  switch (vType) {
    case 'car':
      return AssetImage('${imgPath}car.png');
    case 'motor':
      return AssetImage('${imgPath}motor.png');
    case 'truck':
    default:
      return AssetImage('${imgPath}truck.png');
  }
}

Widget getImage(var img) {
  try {
    if (img != '-') {
      return CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(img),
      );
    } else {
      return const CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('img/icon/driver.png'),
      );
    }
  } catch (e) {
    return const CircleAvatar(
      radius: 25,
      backgroundImage: AssetImage('img/icon/driver.png'),
    );
  }
}
