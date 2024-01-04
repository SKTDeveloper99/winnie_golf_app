import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Screen2 extends StatefulWidget {

  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  _imgFromCamera() async {
    final image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });

  }

  _imgFromGallery() async {
    final image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        }
        );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Image.asset('assets/replace.jpg'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Do you want to change the current image?")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _image = null;
                Navigator.of(context).pop();
                _showPicker();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Padding buildImageContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        child: _image == null
            ? Column(
          children: [
            IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
              iconSize: 40,
              onPressed: () {
                _showPicker();
              }
            ),
            const Text('Input your amazing picture here!'),
          ],
        )
            : Stack(children: [
          Image.file(
            File(_image!.path),
          ),
          Positioned(
              top: 5,
              right: 0, //give the values according to your requirement
              child: MaterialButton(
                onPressed: () {
                  _showMyDialog();
                },
                color: const Color.fromRGBO(243, 222, 186, 1),
                // padding: EdgeInsets.all(16),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.edit,
                  size: 24,
                ),
              ))
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Image.network("https://threebestrated.com/images/KuraRevolvingSushiBar-Irvine-CA.jpeg"),
              const Text(
                "Things 2......",
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
              buildImageContainer(),
            ] // Container
        ),
      ), // Scaffold
    ); // MaterialApp
  }
}
