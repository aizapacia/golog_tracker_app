import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tracker/auth/auth_provider.dart';
import 'package:tracker/controller/api_controller.dart';
import 'package:tracker/widgets/dialogbox.dart';

import '../login_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var controller = ApiController();

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 215, 20, 102),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Profile',
              style: GoogleFonts.publicSans(
                textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              )),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          actions: [
            TextButton(
                onPressed: () => showDialogBox(
                        context,
                        Image.asset(
                          'img/icon/logout.png',
                          width: 60,
                        ),
                        'Are you sure you want to logout?',
                        'Log out', () {
                      ap.userSignOut().then((value) {
                        context.read<LoginCubit>().logout();
                        context.go(context.namedLocation('Login'));
                      });
                    }),
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    Text(
                      '  Logout',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
            const SizedBox(width: 10.0)
          ],
        ),
        body: FutureBuilder(
          future: controller.getData('/myprofile', true),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return layout(
                    snapshot.data['profile'],
                    snapshot.data['user']['name'],
                    snapshot.data['user']['phone'],
                    snapshot.data['user']['address'],
                    snapshot.data['user']['email']);
              } else {
                return layout('', '-', '-', '-', '-');
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 221, 13, 93),
                ),
              );
            }
          },
        ));
  }

  textContent(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.maxFinite,
      decoration: const BoxDecoration(
        border: Border(
          bottom:
              BorderSide(width: 1.0, color: Color.fromARGB(255, 192, 189, 189)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.publicSans(
              textStyle: const TextStyle(
                color: Color.fromARGB(110, 75, 69, 92),
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            content,
            style: GoogleFonts.publicSans(
              textStyle: const TextStyle(
                color: Color(0xFF4B465C),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  layout(String? img, String name, String phone, String address, String email) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 110,
              color: const Color(0xFFD71466),
            ),
            const SizedBox(height: 130),
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(builder: (BuildContext context) {
            //         return EditProfileScreen(img: img.toString());
            //       }),
            //     );
            //   },
            //   child: Text(
            //     'Edit My Profile',
            //     style: Theme.of(context).textTheme.labelMedium,
            //   ),
            // ),
            textContent('Phone Number', phone),
            textContent('Address', address),
            textContent('Email', email),
          ],
        ),
        Positioned(
          top: 10,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
              border: Border.all(color: const Color(0xFFDFE0EB), width: 3.0),
              color: Colors.transparent,
            ),
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: setProfile(img),
            ),
          ),
        ),
      ],
    );
  }

  setProfile(String? img) {
    if (img != '-') {
      return NetworkImage(img!);
    } else {
      return const AssetImage('img/icon/profile.png');
    }
  }
}
