import 'package:flutter/material.dart';

class OrderException {
  noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage('img/error/emptyBox.png'),
            width: 100,
          ),
          Text('No Orders Yet'),
        ],
      ),
    );
  }

  internalError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Image(
            image: AssetImage('img/error/internal.png'),
            width: 250,
          ),
          Text(
            'Sorry, unexpected error',
            style: TextStyle(
              fontSize: 25,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 7),
          Text(
            "We are working on fixing the problem. Be back soon.",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
