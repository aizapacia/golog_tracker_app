import 'package:flutter/material.dart';

final List<Color> statusColor = [
  const Color.fromARGB(255, 128, 118, 241),
  const Color.fromARGB(255, 247, 195, 37),
  const Color.fromARGB(255, 189, 52, 209),
  const Color.fromARGB(255, 26, 174, 159),
  const Color.fromARGB(255, 211, 69, 91),
  Colors.orange,
  Colors.grey
];

Widget getstatus(int status) {
  String label;
  int num;

  switch (status) {
    case 1:
      label = 'ACTIVE';
      num = 0;
      break;
    case 3:
      //label = 'IN TRANSIT';
      label = 'ASSIGNED DRIVER';
      num = 1;
      break;
    case 4:
      label = 'OUT FOR DELIVERY';
      num = 2;
      break;
    case 5:
      label = 'DELIVERED';
      num = 2;
      break;
    case 6:
      label = 'COMPLETED';
      num = 3;
      break;
    case 10:
      label = 'CANCELLED';
      num = 4;
      break;
    case 11:
      label = 'CLOSE STORE';
      num = 4;
      break;
    case 12:
      label = 'OUTSTATION';
      num = 5;
      break;
    default:
      label = 'NOT DEFINED';
      num = 6;
      break;
  }

  return Container(
    padding: const EdgeInsets.all(6.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: statusColor[num],
    ),
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
