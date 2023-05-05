import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String img; //, name, address, phone, email;
  const EditProfileScreen({super.key, required this.img});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }

//FORM VARIABLES
  final userFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 215, 20, 102),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Edit Profile',
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
      ),
      body: SingleChildScrollView(
        child: layout(),
      ),
    );
  }

  setProfile(String? img) {
    if (img != '-') {
      try {
        return NetworkImage(
            'https://gologs3.s3.ap-southeast-1.amazonaws.com/$img');
      } catch (e) {
        return const AssetImage('img/icon/profile.png');
      }
    } else {
      return const AssetImage('img/icon/profile.png');
    }
  }

  Widget textInput(String hint) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: TextFormField(
        // obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: hint,
        ),
        validator: (value) {
          if (value!.isNotEmpty && value.length > 1) {
            return null;
          } else {
            return 'Enter your $hint';
          }
        },
      ),
    );
  }

  layout() {
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
            Form(
              key: userFormKey,
              child: Column(
                children: [
                  textInput('First Name'),
                  textInput('Last Name'),
                  textInput('Email'),
                  textInput('Phone Number'),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 215, 20, 102),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {},
                            child: const Text('Save')),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  const Color.fromARGB(255, 215, 20, 102),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel')),
                      ),
                    ],
                  ),
                ],
              ),
            )
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
            child: image != null
                ? CircleAvatar(
                    radius: 49,
                    backgroundImage: Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    ).image,
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: setProfile(widget.img),
                  ),
          ),
        ),
        Positioned(
            top: 180,
            child: RawMaterialButton(
              onPressed: () {
                myAlert();
              },
              elevation: 2.0,
              fillColor: const Color.fromARGB(255, 215, 20, 102),
              padding: const EdgeInsets.all(15.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20.0,
              ),
            )),
      ],
    );
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: const Color.fromARGB(255, 237, 238, 251),
            title: const Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 215, 20, 102),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 215, 20, 102),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    //if user click this button. user can upload image from camera
                    onPressed: () async {
                      setState(() {
                        image = null;
                      });
                      Navigator.pop(context, 'Cancel');
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.delete_outline),
                        Text('Cancel Change'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
