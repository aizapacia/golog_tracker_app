import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracker/widgets/order_driver.dart';

import '../../widgets/status.dart';

class MapLocationScreen extends StatefulWidget {
  final double lat, lng;
  // ignore: prefer_typing_uninitialized_variables
  final driverData;
  final String orderID;
  const MapLocationScreen(
      {super.key,
      required this.lat,
      required this.lng,
      required this.driverData,
      required this.orderID});

  @override
  State<MapLocationScreen> createState() => _MapLocationScreenState();
}

class _MapLocationScreenState extends State<MapLocationScreen> {
  //MAP
  final Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: 160,
          child: Row(
            children: [
              const Text(
                'Order ID',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color.fromARGB(255, 215, 20, 102),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                widget.orderID,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Color.fromARGB(255, 62, 61, 61),
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFFD71466),
        ),
        actions: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 231, 230, 230),
                  width: 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.only(top: 12, bottom: 12, right: 15),
            child: getstatus(widget.driverData['orderLog']['status']),
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lng),
          zoom: 15,
        ),
        //zoomControlsEnabled: false,
        onMapCreated: (controller) {
          addMarker('', LatLng(widget.lat, widget.lng));
        },
        markers: _markers.values.toSet(),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 135,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Container(
            color: Colors.white,
            //padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
            child: orderDriver(widget.driverData)),
      ),
    );
  }

  addMarker(String id, LatLng location) {
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      // infoWindow: InfoWindow(
      //   // title: _location[2],
      //   // snippet: _location[3],
      // ),
    );

    _markers[id] = marker;
    setState(() {});
  }
}
