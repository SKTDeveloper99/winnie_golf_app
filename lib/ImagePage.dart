import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final List links;
  final String score;

  ImagePage({
    Key? key,
    required this.score,
    required this.links,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFD5D4F9), // Change app bar color
        toolbarHeight: 100,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                'Score: $score',
                style:
                const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: links.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildImageCard(context, index, height);
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(BuildContext context, int index, double height) {
    return Card(
      color: const Color.fromRGBO(215, 236, 209, 1), // Change the button color

      child: ListView(
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
            height: height * 0.4,
            child: Image.network(
              links[index][0],
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(
            height: height * 0.4,
            child: Image.network(
              links[index][1],
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
