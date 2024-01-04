import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ResultPage extends StatefulWidget {
  ResultPage({
    Key? key,
    required this.title,
    required this.video1File,
    required this.video2File,
  }) : super(key: key);
  XFile video1File;
  XFile video2File;
  final String title;

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List links = [];
  String score = '';

  @override
  void initState() {
    super.initState();
    uploadFileToServer();
  }

  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dates = [];
    dates = prefs.getStringList('date') ?? [];

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd hh:mm a');
    String formattedDate = formatter.format(now);
    dates.add(formattedDate);
    prefs.setStringList('date', dates);
    prefs.setString('${formattedDate}_link', json.encode(links));
    prefs.setString('${formattedDate}_scores', score);
  }

  void uploadFileToServer() async {
    // This url is for local server. Then this url'll change to the public url
    // var url = 'http://10.0.2.2:5000/'; // local host
    var url = 'http://3.16.55.7:5000'; // AWS/ec2 host
    print(url);
    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000"
    };

    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('$url/analyze')); //post request to URL/analize
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'video1',
        widget.video1File.path,
        contentType: MediaType('application', 'MP4'), //Media type
      ),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'video2',
        widget.video2File.path,
        contentType: MediaType('application', 'MP4'),
      ),
    );

    request.send().then((r) async {
      print(r.statusCode);

      if (r.statusCode == 200) {
        // print((json.decode(await r.stream.transform(utf8.decoder).join())).runtimeType);
        var result = json.decode(await r.stream.transform(utf8.decoder).join());
        print(result);
        setState(() {
          score = double.parse(result[0]).toStringAsFixed(2);
          links = result[1];
          _saveData();
        });
      } else {
        Text("Video is not accepted because of the format error");
        print('Error request');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(152, 33, 118, 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        toolbarHeight: 100,
      ),
      body: links.isNotEmpty
          ? Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Text(
                  'Score: $score',
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: links.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ListTile(
                          title: Text(
                            'Image ${index + 1}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                            height: height * 0.5,
                            child: Image.network(
                              links[index][0],
                              fit: BoxFit.fitHeight,
                            )),
                        SizedBox(
                            height: height * 0.5,
                            child: Image.network(
                              links[index][1],
                              fit: BoxFit.fitHeight,
                            )),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                ),
              ],
            ),
          ))
          : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Analyzing videos'),
              )
            ],
          )),
    );
  }
}