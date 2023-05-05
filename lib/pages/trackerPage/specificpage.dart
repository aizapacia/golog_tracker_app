import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracker/controller/api_controller.dart';
import 'package:tracker/pages/trackerPage/map.dart';
import 'package:tracker/widgets/order_driver.dart';
import 'package:tracker/widgets/order_exceptions.dart';

import '../../widgets/status.dart';

class SpecificOrderPage extends StatefulWidget {
  final int id;
  final int status;
  const SpecificOrderPage({super.key, required this.id, required this.status});

  @override
  State<SpecificOrderPage> createState() => _SpecificOrderPageState();
}

class _SpecificOrderPageState extends State<SpecificOrderPage> {
  final Map<String, Marker> _markers = {};

  int currentStep = 0;

  late var controller = ApiController().getData('/order/${widget.id}', true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
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
                  widget.id.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
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
              child: getstatus(widget.status),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: controller,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data.length >= 4) {
                    return Column(
                      children: [
                        //GOOGLE MAP
                        Stack(
                          children: [
                            SizedBox(
                              height: 300,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      snapshot.data['orderLog']['lat'],
                                      snapshot.data['orderLog']['lng']),
                                  zoom: 12,
                                ),
                                zoomControlsEnabled: false,
                                onMapCreated: (controller) {
                                  addMarker(
                                      '-',
                                      LatLng(snapshot.data['orderLog']['lat'],
                                          snapshot.data['orderLog']['lng']));
                                },
                                markers: _markers.values.toSet(),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (widget.status == 1 ||
                                    widget.status == 3 ||
                                    widget.status == 4 ||
                                    widget.status == 6) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return MapLocationScreen(
                                          lat: snapshot.data['orderLog']['lat'],
                                          lng: snapshot.data['orderLog']['lng'],
                                          driverData: snapshot.data,
                                          orderID: widget.id.toString());
                                    }),
                                  );
                                }
                              },
                              child: Container(
                                height: 299,
                                width: double.infinity,
                                color: const Color.fromARGB(0, 252, 249, 251),
                              ),
                            ),
                            if (widget.status == 1 ||
                                widget.status == 3 ||
                                widget.status == 4 ||
                                widget.status == 6) ...[
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.92,
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.only(top: 190),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  child: orderDriver(snapshot.data),
                                ),
                              )
                            ]
                          ],
                        ),
                        //TRACK SUMMARY
                        Container(
                          width: MediaQuery.of(context).size.width * 0.92,
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 5),
                                padding: const EdgeInsets.only(bottom: 5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Track Summary',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 215, 20, 102),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),

                              //LOOOP DATA
                              for (int x = 0;
                                  x <= snapshot.data['timeline'].length - 1;
                                  x++) ...[
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 8, right: 5),
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 159, 67),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 244, 222, 200),
                                              width: 5,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            snapshot.data['timeline'][x]
                                                ['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Color.fromARGB(
                                                  255, 75, 70, 92),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      snapshot.data['timeline'][x]['date'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: const EdgeInsets.only(left: 17),
                                  padding: const EdgeInsets.only(
                                      left: 25.0, top: 10.0),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color:
                                            Color.fromARGB(255, 219, 218, 222),
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 40.0,
                                    child: Text(snapshot.data['timeline'][x]
                                        ['description']),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        //ORDER SUMMARY
                        Container(
                          width: MediaQuery.of(context).size.width * 0.92,
                          padding: const EdgeInsets.all(10.0),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 215, 20, 102),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 5),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                //ORDER PICTURE AND NAME
                                child: Row(
                                  children: [
                                    //ORDER IMAGE
                                    getOrderImage(
                                        snapshot.data['img']['order']),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    //ORDER NAME
                                    Flexible(
                                      child: Text(
                                        snapshot.data['itemInfo']['name'] ??
                                            '-',
                                        style: const TextStyle(
                                          color: Color(0xFF4B465C),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //ORDER QTY
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 5),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data['itemInfo']['item_type'] ??
                                          '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Item Type',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //ORDEDR WEIGHT
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 5),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data['itemInfo']['category'] ??
                                          '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Category',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //ORDER REMARKS
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 5),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data['orderLog']['remarks'] ??
                                          '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Remarks',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //ADDITIONAL INFORMATION
                        Container(
                          width: MediaQuery.of(context).size.width * 0.92,
                          padding: const EdgeInsets.all(15.0),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Additional Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 215, 20, 102),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //ORDER ID
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 5),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.id.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Order ID',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //PHONE NUMBER
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data['orderLog']['contact'] ??
                                          '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              //FULL ADDRESS
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data['orderLog']['address'] ??
                                          '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Full Address',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.only(top: 5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Color.fromARGB(255, 231, 230, 230),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data['orderLog']['name'] ?? '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Full Name',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        //PICKUP IMAGE
                        if (widget.status != 1) ...[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.92,
                            padding: const EdgeInsets.all(15.0),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pickup Image',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 15),
                                getImage(snapshot.data['img']['pickup'])
                              ],
                            ),
                          ),
                        ],
                        if (widget.status == 6) ...[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.92,
                            padding: const EdgeInsets.all(15.0),
                            margin: const EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Proof of Delivery',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 15),
                                getImage(snapshot.data['img']['delivered'])
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 50),
                      ],
                    );
                  } else {
                    return OrderException().noData();
                  }
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(height: 100),
                      CircularProgressIndicator(
                        color: Color.fromARGB(255, 221, 13, 93),
                      ),
                      SizedBox(height: 20),
                      Text('Loading')
                    ],
                  ));
                } else {
                  return OrderException().noData();
                }
              }),
        ));
  }

  addMarker(String id, LatLng location) {
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(
        title: '',
        snippet: '',
      ),
    );

    _markers[id] = marker;
    setState(() {});
  }

  //RETURN PICKUP IMAGE
  getImage(var img) {
    if (img != '-') {
      return Center(
        child: Image(
          image: NetworkImage(img),
          width: 250,
        ),
      );
    } else {
      return Center(
        child: Text(
          'No Image Available',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
  }

  //RETURN PICKUP IMAGE
  getOrderImage(var img) {
    if (img != '-') {
      return CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(img),
      );
    } else {
      return const CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage('img/icon/order.png'),
      );
    }
  }
  //end
}
