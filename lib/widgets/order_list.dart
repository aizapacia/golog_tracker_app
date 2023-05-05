import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget orderList(orderData, datename, status) {
  return ListView.builder(
      itemCount: orderData.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                context.push(
                  context.namedLocation(
                    'SpecificOrder',
                    params: {
                      'status': status.toString(),
                      'id': orderData[index]['id'].toString(),
                    },
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 227, 226, 227)
                          .withOpacity(0.6),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                          color: Color.fromARGB(255, 231, 230, 230),
                          width: 1.0,
                        )),
                      ),
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Order ID',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD81466),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            orderData[index]['id'].toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF4B465C),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          color: Color(0xFFD81466),
                        ),
                        const SizedBox(width: 5.0),
                        Flexible(
                          child: Text(
                            orderData[index]['fromaddress'].toString(),
                            style: const TextStyle(
                              color: Color(0xFF4B465C),
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_sharp,
                          color: Color(0xFFD81466),
                        ),
                        const SizedBox(width: 5.0),
                        Flexible(
                          child: Text(
                            orderData[index]['address'].toString(),
                            style: const TextStyle(
                              color: Color(0xFF4B465C),
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: Color(0xFFF8F8F8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            datename + '   ',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFD71466),
                            ),
                          ),
                          Text(
                            orderData[index]['ddate'].toString(),
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF4B465C),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      });
}
