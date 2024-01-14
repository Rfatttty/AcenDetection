// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'dart:async';

import 'package:acne_camera/selectModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:logger/logger.dart';
import 'package:image/image.dart' as img;

class RunModelByMultiImageDemo extends StatefulWidget {
  const RunModelByMultiImageDemo({Key? key, required this.images})
      : super(key: key);

  final List<XFile> images;

  @override
  _RunModelByMultiImageState createState() => _RunModelByMultiImageState();
}

class _RunModelByMultiImageState extends State<RunModelByMultiImageDemo> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    if (widget.images.length == 3) {
      _pageController = PageController(initialPage: 1);
    } else {
      _pageController = PageController(initialPage: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('照片預覽'),
        centerTitle: true,
        // leading: null,
      ),
      body: WillPopScope(
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: [
            for (var i = 0; i < widget.images.length; i++)
              RunModelPage(image: widget.images[i]),
          ],
        ),
        onWillPop: () async {
          final shouldPop = await showDialog<bool?>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                '您是否要返回首頁',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              actions: [
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text('YES'),
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                    builder: (context) {
                      return const SelectMode();
                    },
                  ), (route) => false),
                ),
              ],
            ),
          );
          return shouldPop ?? false;
        },
      ),
    );
  }
}

class RunModelPage extends StatefulWidget {
  const RunModelPage({Key? key, required this.image}) : super(key: key);

  final XFile image;

  @override
  _RunModelPageState createState() => _RunModelPageState();
}

class _RunModelPageState extends State<RunModelPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late ModelObjectDetection _objectModel;

  String? textToShow;

  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];

  List objectlist = [];
  List labellist = [];

  int total = 0;
  int count1 = 0; //白頭
  int count2 = 0; //黑頭
  int count3 = 0; //丘疹
  int count4 = 0; //膿皰
  int count5 = 0; //結節
  int count6 = 0; //囊腫

  @override
  void initState() {
    super.initState();
    // loadModel();
    runObjectDetectionInGallery(widget.image);
  }

  Future runObjectDetectionInGallery(XFile imageXFile) async {
    //
    String pathObjectDetectionModelYolov5 = "assets/models/best.torchscript";

    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModelYolov5, 6, 640, 640,
          labelPath: "assets/labels/labels_acen.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov5);
      Logger().d("loadModel成功");
    } catch (e) {
      if (e is PlatformException) {
        Logger().e("only supported for android, Error is $e");
      } else {
        Logger().e("Error is $e");
      }
    }

    // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    // if (image == null) return;
    // print(image.path);

    objDetect = await _objectModel.getImagePrediction(
        await File(widget.image.path).readAsBytes(),
        minimumScore: 0.1,
        iOUThreshold: 0.3);

    objectlist.clear();
    labellist.clear(); //清空list

    for (var element in objDetect) {
      switch (element?.classIndex) {
        case 0:
          count1++;
          break;
        case 1:
          count2++;
          break;
        case 2:
          count3++;
          break;
        case 3:
          count4++;
          break;
        case 4:
          count5++;
          break;
        case 5:
          count6++;
      }
      total = count1 + count2 + count3 + count4 + count5 + count6;

      objectlist.add({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });

      Logger().i({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: FutureBuilder(
        future: runObjectDetectionInGallery(widget.image),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 如果任务正在进行中，显示进度指示器
            return const Center(
              child: CircularProgressIndicator(),
            );
            // return const Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       SizedBox(
            //         height: 50.0,
            //         width: 50.0,
            //         child: CircularProgressIndicator(
            //           color: Colors.blue,
            //           strokeWidth: 5,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 20,
            //       ),
            //       Text(
            //         'Loading...',
            //         style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            //       )
            //     ],
            //   ),
            // );
          } else if (snapshot.hasError) {
            // 如果任务出错，显示错误信息
            print('=====发生错误: ${snapshot.error}=====');
            return Text('发生错误: ${snapshot.error}');
          } else {
            // return const Text('成功');

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  // height: MediaQuery.of(context).size.height*0.6,
                  child: objDetect.isNotEmpty
                      ? widget.image == null
                          ? const Text('No image selected.')
                          : _objectModel.renderBoxesOnImage(
                              File(widget.image.path), objDetect)
                      : widget.image == null
                          ? const Center(
                              child: Text('No image selected.'),
                            )
                          : Image.file(
                              File(widget.image.path),
                              alignment: Alignment.topCenter,
                              scale: MediaQuery.of(context).size.height/img.decodeImage(File(widget.image.path).readAsBytesSync())!.height,
                            ),
                ),
                Center(
                  child: Visibility(
                    // visible: textToShow != null,
                    visible: true,
                    child: Text(
                        "總顆數:$total\n白頭粉刺總數:$count1\n黑頭粉刺總數:$count2\n丘疹總數:$count3\n膿泡總數:$count4\n結節總數:$count5\n囊腫總數:$count6",
                        maxLines: 7,
                        style: const TextStyle(fontSize: 25)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                )
              ],
            );
          }
        },
      ),
    );
  }
}
