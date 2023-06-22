import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? input;
  ScreenshotController screenshotC = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Generator"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 2,
            child: input == null
                ? Text(
                    "Masukkan Text Untuk Generate QR",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  )
                : Screenshot(
                    controller: screenshotC,
                    child: QrImageView(
                      backgroundColor: Colors.white,
                      data: input!,
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                if (value != "") {
                  input = value;
                  setState(() {});
                } else {
                  input = null;
                  setState(() {});
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              screenshotC
                  .capture(delay: Duration(milliseconds: 10))
                  .then((capturedImage) async {
                SaveImage(context, capturedImage!);
              }).catchError((onError) {
                print(onError);
              });
            },
            child: Text("Save QR Image File"),
          )
        ]),
      ),
    );
  }

  Future<dynamic> SaveImage(BuildContext context, Uint8List image) async {
    var filename = 'images/$input.png';
    final file = File(filename);
    await file.writeAsBytes(image);
  }
}
