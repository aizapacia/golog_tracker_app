import 'package:flutter/material.dart';

import '../../controller/api_controller.dart';
import '../../widgets/order_exceptions.dart';
import '../../widgets/order_list.dart';

class OutforDeliveryPage extends StatelessWidget {
  OutforDeliveryPage({super.key});

  late final controller = ApiController().getData('/outfordeliveryorder', true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 236, 236),
      body: FutureBuilder(
        future: controller,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data['isEmpty'] == true) {
              return orderList(
                  snapshot.data['order'], 'Est. time of arrival', 4);
            } else {
              return OrderException().noData();
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 221, 13, 93),
              ),
            );
          } else {
            return OrderException().noData();
          }
          //
        },
      ),
    );
  }
}
