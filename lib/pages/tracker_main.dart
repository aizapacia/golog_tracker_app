import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/auth/auth_provider.dart';
import 'package:tracker/pages/trackerPage/active.dart';
import 'package:tracker/pages/trackerPage/cancelled.dart';
import 'package:tracker/pages/trackerPage/completed.dart';
import 'package:tracker/pages/trackerPage/intransit.dart';
import 'package:tracker/pages/trackerPage/outfordelivery.dart';

class TrackerMainScreen extends StatefulWidget {
  const TrackerMainScreen({super.key});

  @override
  State<TrackerMainScreen> createState() => _TrackerMainScreenState();
}

class _TrackerMainScreenState extends State<TrackerMainScreen> {
  final String profilePic = AuthProvider.userProfile;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffF5F5F5),
          automaticallyImplyLeading: false,
          title: Text('Orders',
              style: GoogleFonts.publicSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFFD71466),
                ),
              )),

          //BACK BUTTON
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xFFD71466),
          ),

          //RIGHT ICONS [SEARCH - NOTIFICATION - PROFILE]
          actions: [
            //SEARCH
            IconButton(
              icon: const Icon(Icons.search_sharp),
              onPressed: () => context.push(context.namedLocation('Search')),
              color: const Color(0xFFD71466),
            ),
            //NOTIFICATION
            // IconButton(
            //   icon: const Icon(Icons.notifications),
            //   onPressed: () {
            //     //
            //   },
            //   color: const Color(0xFFC5C7CD),
            // ),
            //PROFILE

            GestureDetector(
              child: profilePic != '-'
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(profilePic),
                    )
                  : const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('img/icon/profile.png')),
              onTap: () => context.push(context.namedLocation('Profile')),
            ),
            const SizedBox(width: 10)
          ],

          //STATUS TABS
          bottom: TabBar(
            isScrollable: true,
            unselectedLabelColor: const Color(0xFF4B465C),
            indicatorColor: const Color(0xFFD71466),
            labelColor: const Color(0xFFD71466),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
            tabs: [
              tab('Active'),
              tab('Assigned Driver'),
              tab('Out for Delivery'),
              tab('Completed'),
              tab('Cancelled')
            ],
          ),
        ),
        body: TabBarView(children: [
          ActivePage(),
          InTransitPage(),
          OutforDeliveryPage(),
          CompletedPage(),
          CancelledPage(),
        ]),
      ),
    );
  }

  tab(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(title,
          style: GoogleFonts.publicSans(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )),
    );
  }
}
