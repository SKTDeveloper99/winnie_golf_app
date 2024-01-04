import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:winnie_golf_app/ResultPage.dart';
import 'package:winnie_golf_app/video_items.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key}) : super(key: key);


  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  VideoPlayerController? _controller1;
  VideoPlayerController? _controller2;
  XFile? _video1File;
  XFile? _video2File;

  final ImagePicker _picker = ImagePicker();

  Future<void> _setVideoController(XFile file, isVideo1) async {
    if (file != null && mounted) {
      VideoPlayerController controller;
      print('play video ');
      if (kIsWeb) {
        controller = VideoPlayerController.networkUrl(Uri.parse(file.path));
        print('network:' + file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
        print('file:' + file.path);
      }
      setState(() {
        if (isVideo1) {
          _controller1 = controller;
        } else {
          _controller2 = controller;
        }
      });
    }
  }

  void _onVideo1ButtonPressed(ImageSource source) async {
    _video1File = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    await _setVideoController(_video1File!, true);
  }

  void _onVideo2ButtonPressed(ImageSource source) async {
    _video2File = await _picker.pickVideo(
        source: source, maxDuration: const Duration(seconds: 10));
    await _setVideoController(_video2File!, false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _controller1 != null && _controller2 != null
          ? SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromRGBO(152, 33, 118, 1),
                  Color.fromRGBO(255, 229, 173, 1)
                ]),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                Container(
                  height: 250,
                  color: Colors.black,
                  child: VideoItems(
                    videoPlayerController: _controller1!,
                    autoplay: false,
                    looping: false,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 250,
                  color: Colors.black,
                  child: VideoItems(
                    videoPlayerController: _controller2!,
                    autoplay: false,
                    looping: false,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(241, 26, 123, 1),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => ResultPage(
                                  title: 'Golf AI Coach',
                                  video1File: _video1File!,
                                  video2File: _video2File!,
                                )));
                      },
                      child: const Text(
                        'Analyze Videos',
                        style: TextStyle(fontSize: 30),
                      )),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      )
          : Center(
          child: Container(
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromRGBO(152, 33, 118, 1),
                    Color.fromRGBO(255, 229, 173, 1)
                  ]),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'GolfCoach++',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(255, 229, 173, 1),
                      ),
                      onPressed: () {
                        _onVideo1ButtonPressed(ImageSource.gallery);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.upload_rounded,
                            size: 50.0,
                            semanticLabel: 'Upload Video #1',
                            color: Color.fromRGBO(62, 0, 31, 1),
                          ),
                          Text('Upload Video #1',
                              style: TextStyle(
                                  color: Color.fromRGBO(62, 0, 31, 1))),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    _video1File != null
                        ? _video1File!.path.split('/')[6]
                        : '',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(255, 229, 173, 1),
                      ),
                      onPressed: () {
                        _onVideo2ButtonPressed(ImageSource.gallery);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.upload_rounded,
                            size: 50.0,
                            semanticLabel: 'Upload Image',
                            color: Color.fromRGBO(62, 0, 31, 1),
                          ),
                          Text('Upload Video #2',
                              style: TextStyle(
                                  color: Color.fromRGBO(62, 0, 31, 1))),
                        ],
                      ),
                    ),
                  ),
                  Text(
                      _video2File != null
                          ? _video2File!.path.split('/')[6]
                          : '',
                      textAlign: TextAlign.center),
                ]),
          )),
    );
  }
}
