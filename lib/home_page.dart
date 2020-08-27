import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';

import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

import 'package:maverick_video_editor/editor.dart';

import 'package:video_trimmer/video_trimmer.dart';

class HomePage extends StatelessWidget {
  final Trimmer _trimmer = Trimmer();
  String fileName;
  List<Filter> filters = presetFiltersList;
  File imageFile;
  Future getImage(context) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Apply Filter"),
          image: image,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      imageFile = imagefile['image_filtered'];
      print(imageFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25.0),
                        bottomRight: Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.2, 1],
                        colors: [Colors.blue, Colors.white],
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 65.0,
                        child: Center(
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height / 2.5 - 65.0,
                        child: Center(
                          child: Image.asset('assets/images/top.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    File file = await ImagePicker.pickVideo(
                      source: ImageSource.gallery,
                    );
                    if (file != null) {
                      await _trimmer.loadVideo(videoFile: file);
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return TrimmerView(_trimmer);
                      }));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    width: MediaQuery.of(context).size.width / 1.15,
                    height: 120.0,
                    padding: EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      gradient: LinearGradient(
                        colors: GradientColors.blue,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 65.0,
                          width: 65.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/video.png'),
                                  fit: BoxFit.fill)),
                        ),
                        Text(
                          'Trim a Video',
                          style: TextStyle(color: Colors.white, fontSize: 24.0),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getImage(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25.0),
                    width: MediaQuery.of(context).size.width / 1.15,
                    height: 120.0,
                    padding: EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      gradient: LinearGradient(
                        colors: GradientColors.orange,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 65.0,
                          width: 65.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/lens.png'),
                                  fit: BoxFit.fitWidth)),
                        ),
                        Text(
                          'Add Filters',
                          style: TextStyle(color: Colors.white, fontSize: 24.0),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
