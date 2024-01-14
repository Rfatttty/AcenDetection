// ignore_for_file: library_private_types_in_public_api

import 'package:acne_camera/selectModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:logger/logger.dart';

class RunModelByImageDemo extends StatefulWidget {
  const RunModelByImageDemo({Key? key}) : super(key: key);

  @override
  _RunModelByImageDemoState createState() => _RunModelByImageDemoState();
}

class _RunModelByImageDemoState extends State<RunModelByImageDemo> {
  // ClassificationModel? _imageModel;

  late ModelObjectDetection _objectModel;

  // late ModelObjectDetection _objectModelYolov8;
  // late ModelObjectDetection _objectModelDinosaurWithAI;
  // late ModelObjectDetection _objectModelHelmet;

  String? textToShow;

  // String? _imagePrediction;
  // List? _prediction;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];

  var logger = Logger();

  List objectlist = [];
  List labellist = [];

  int total = 0;
  int count1 = 0;
  int count2 = 0;
  int count3 = 0;
  int count4 = 0;
  int count5 = 0;
  int count6 = 0;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  //load your model
  Future loadModel() async {
    // String pathImageModel = "assets/models/model_classification.pt";
    // String pathObjectDetectionModelYolov5 = "assets/models/yolov5s.torchscript";
    String pathObjectDetectionModelYolov5 = "assets/models/best.torchscript";

    // String pathObjectDetectionModelYolov8 = "assets/models/yolov8s.torchscript";
    // String pathObjectDetectionModelDinosaurWithAI =
    //     "assets/models/dinosaurwithAI.torchscript.pt";
    // String pathObjectDetectionModelHelmet =
    //     "assets/models/helmet.torchscript.pt";

    try {
      // _imageModel = await PytorchLite.loadClassificationModel(
      //     pathImageModel, 224, 224, 1000,
      //     labelPath: "assets/labels/label_classification_imageNet.txt");

      // _objectModel = await PytorchLite.loadObjectDetectionModel(
      //     pathObjectDetectionModelYolov5, 80, 640, 640,
      //     labelPath: "assets/labels/labels_objectDetection_Coco.txt",
      //     objectDetectionModelType: ObjectDetectionModelType.yolov5);

      _objectModel = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModelYolov5, 6, 640, 640,
          labelPath: "assets/labels/labels_acen.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov5);

      // _objectModelYolov8 = await PytorchLite.loadObjectDetectionModel(
      //     pathObjectDetectionModelYolov8, 80, 640, 640,
      //     labelPath: "assets/labels/labels_objectDetection_Coco.txt",
      //     objectDetectionModelType: ObjectDetectionModelType.yolov8);
      // _objectModelDinosaurWithAI = await PytorchLite.loadObjectDetectionModel(
      //     pathObjectDetectionModelDinosaurWithAI, 3, 640, 640,
      //     labelPath: "assets/labels/labels_objectDetection_Coco.txt",
      //     objectDetectionModelType: ObjectDetectionModelType.yolov5);
      //
      // _objectModelHelmet = await PytorchLite.loadObjectDetectionModel(
      //     pathObjectDetectionModelHelmet, 4, 640, 640,
      //     labelPath: "assets/labels/labels_objectDetection_Coco.txt",
      //     objectDetectionModelType: ObjectDetectionModelType.yolov5);
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  //run an image model
  // Future runObjectDetectionWithoutLabels() async {
  //   //pick a random image
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   objDetect = await _objectModel.getImagePrediction(
  //       await File(image!.path).readAsBytes(),
  //       minimumScore: 0.1,
  //       iOUThreshold: 0.3);
  //
  //   for (var element in objDetect) {
  //     print({
  //       "score": element?.score,
  //       "className": element?.className,
  //       "class": element?.classIndex,
  //       "rect": {
  //         "left": element?.rect.left,
  //         "top": element?.rect.top,
  //         "width": element?.rect.width,
  //         "height": element?.rect.height,
  //         "right": element?.rect.right,
  //         "bottom": element?.rect.bottom,
  //       },
  //     });
  //   }
  //   setState(() {
  //     //this.objDetect = objDetect;
  //     _image = File(image.path);
  //   });
  // }

  Future runObjectDetectionInCamera() async {
    total = 0;
    count1 = 0;
    count2 = 0;
    count3 = 0;
    count4 = 0;
    count5 = 0;
    count6 = 0;

    // final XFile? image = await _picker.pickMultiImage();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    Stopwatch stopwatch = Stopwatch()..start();
    if (image == null) return;
    print(image.path);

    objDetect = await _objectModel.getImagePrediction(
        await File(image.path).readAsBytes(),
        minimumScore: 0.1,
        iOUThreshold: 0.3);

    textToShow = inferenceTimeAsString(stopwatch);

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

      logger.i({
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

      labellist.add(element?.className);
    }

    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  Future runObjectDetectionInGallery() async {
    total = 0;
    count1 = 0; //白頭
    count2 = 0; //黑頭
    count3 = 0; //丘疹
    count4 = 0; //膿皰
    count5 = 0; //結節
    count6 = 0; //囊腫

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Stopwatch stopwatch = Stopwatch()..start();
    if (image == null) return;
    print(image.path);

    objDetect = await _objectModel.getImagePrediction(
        await File(image.path).readAsBytes(),
        minimumScore: 0.1,
        iOUThreshold: 0.3);

    textToShow = inferenceTimeAsString(stopwatch);

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

      logger.i({
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

      // print({
      //   "score": element?.score,
      //   "className": element?.className,
      //   "class": element?.classIndex,
      //   "rect": {
      //     "left": element?.rect.left,
      //     "top": element?.rect.top,
      //     "width": element?.rect.width,
      //     "height": element?.rect.height,
      //     "right": element?.rect.right,
      //     "bottom": element?.rect.bottom,
      //   },
      // }.toString());
    }

    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  // Future runObjectDetectionYolov8() async {
  //   //pick a random image
  //   Stopwatch stopwatch = Stopwatch()..start();
  //
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   objDetect = await _objectModelYolov8.getImagePrediction(
  //       await File(image!.path).readAsBytes(),
  //       minimumScore: 0.1,
  //       iOUThreshold: 0.3);
  //   for (var element in objDetect) {
  //     print({
  //       "score": element?.score,
  //       "className": element?.className,
  //       "class": element?.classIndex,
  //       "rect": {
  //         "left": element?.rect.left,
  //         "top": element?.rect.top,
  //         "width": element?.rect.width,
  //         "height": element?.rect.height,
  //         "right": element?.rect.right,
  //         "bottom": element?.rect.bottom,
  //       },
  //     });
  //   }
  //   print(
  //       'object executed in ${stopwatch.elapsed.inMilliseconds} Milliseconds');
  //   setState(() {
  //     //this.objDetect = objDetect;
  //     _image = File(image.path);
  //   });
  // }

  // Future runClassification() async {
  //   objDetect = [];
  //   //pick a random image
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   //get prediction
  //   //labels are 1000 random english words for show purposes
  //   print(image!.path);
  //   _imagePrediction = await _imageModel!
  //       .getImagePrediction(await File(image.path).readAsBytes());
  //
  //   List<double?>? predictionList = await _imageModel!.getImagePredictionList(
  //     await File(image.path).readAsBytes(),
  //   );
  //
  //   print(predictionList);
  //
  //   setState(() {
  //     //this.objDetect = objDetect;
  //     _image = File(image.path);
  //   });
  // }

  // Future runObjectDetectionDinosaurWithAI() async {
  //   //pick a random image
  //   Stopwatch stopwatch = Stopwatch()..start();
  //
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   objDetect = await _objectModelDinosaurWithAI.getImagePrediction(
  //       await File(image!.path).readAsBytes(),
  //       minimumScore: 0.1,
  //       iOUThreshold: 0.3);
  //
  //   for (var element in objDetect) {
  //     print({
  //       "score": element?.score,
  //       "className": element?.className,
  //       "class": element?.classIndex,
  //       "rect": {
  //         "left": element?.rect.left,
  //         "top": element?.rect.top,
  //         "width": element?.rect.width,
  //         "height": element?.rect.height,
  //         "right": element?.rect.right,
  //         "bottom": element?.rect.bottom,
  //       },
  //     });
  //   }
  //   print(
  //       'object executed in ${stopwatch.elapsed.inMilliseconds} Milliseconds');
  //   setState(() {
  //     //this.objDetect = objDetect;
  //     _image = File(image.path);
  //   });
  // }

  // Future runObjectDetectionHelmet() async {
  //   //pick a random image
  //   Stopwatch stopwatch = Stopwatch()..start();
  //
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   objDetect = await _objectModelHelmet.getImagePrediction(
  //       await File(image!.path).readAsBytes(),
  //       minimumScore: 0.1,
  //       iOUThreshold: 0.3);
  //   for (var element in objDetect) {
  //     print({
  //       "score": element?.score,
  //       "className": element?.className,
  //       "class": element?.classIndex,
  //       "rect": {
  //         "left": element?.rect.left,
  //         "top": element?.rect.top,
  //         "width": element?.rect.width,
  //         "height": element?.rect.height,
  //         "right": element?.rect.right,
  //         "bottom": element?.rect.bottom,
  //       },
  //     });
  //   }
  //   print(
  //       'object executed in ${stopwatch.elapsed.inMilliseconds} Milliseconds');
  //   setState(() {
  //     //this.objDetect = objDetect;
  //     _image = File(image.path);
  //   });
  // }

  String inferenceTimeAsString(Stopwatch stopwatch) =>
      "Inference Took ${stopwatch.elapsed.inMilliseconds} ms";

  String getListAmount(List list, String number) {
    String amount;
    amount = list.where((element) => element == number).length.toString();

    return amount;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yolov5模型辨識'),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text(
                        'DATA',
                        style: TextStyle(color: Colors.black),
                      ),
                      scrollable: true,
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "共有${objectlist.length}筆資料",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          for (var i = 0; i < objectlist.length; i++)
                            Padding(
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(
                                    height: 15,
                                    thickness: 3,
                                  ),
                                  Text(
                                    "第${i + 1}筆資料",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "score：${objectlist[i]["score"]}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "className：${objectlist[i]["className"]}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "class：${objectlist[i]["class"]}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "left：${objectlist[i]["rect"]["left"].toStringAsFixed(10)}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "top：${objectlist[i]["rect"]["top"].toStringAsFixed(10)}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "right：${objectlist[i]["rect"]["right"].toStringAsFixed(10)}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "bottom：${objectlist[i]["rect"]["bottom"].toStringAsFixed(10)}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "width：${objectlist[i]["rect"]["width"].toStringAsFixed(10)}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "height：${objectlist[i]["rect"]["height"].toStringAsFixed(10)}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.message_outlined),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: objDetect.isNotEmpty
                  ? _image == null
                      ? const Center(
                          child: Text('No image selected.'),
                        )
                      : _objectModel.renderBoxesOnImage(_image!, objDetect)
              // FutureBuilder<Widget>(
              //             future: _objectModel.renderBoxesOnImageF(
              //                 _image!, objDetect),
              //             builder: (context, snapshot) {
              //               if (snapshot.connectionState ==
              //                   ConnectionState.done) {
              //                 return snapshot.data!;
              //               } else {
              //                 return const Center(
              //                   child: CircularProgressIndicator(),
              //                 );
              //               }
              //             },
              //           )
                  : _image == null
                      ? const Center(
                          child: Text('No image selected.'),
                        )
                      : Image.file(_image!),
            ),
            const SizedBox(
              height: 20,
            ),

            // Expanded(
            //   // height: MediaQuery.of(context).size.height*0.6,
            //   child: objDetect.isNotEmpty
            //       ? _image == null
            //           ? const Text('No image selected.')
            //           : _objectModel.renderBoxesOnImage(_image!, objDetect)
            //       // FutureBuilder<Widget>(
            //       //             future: _objectModel.renderBoxesOnImage(
            //       //                 _image!, objDetect),
            //       //             builder: (context, snapshot) {
            //       //               if (snapshot.connectionState ==
            //       //                   ConnectionState.done) {
            //       //                 return snapshot.data!;
            //       //               } else {
            //       //                 return const Center(
            //       //                     child: CircularProgressIndicator());
            //       //               }
            //       //             },
            //       //           )
            //       : _image == null
            //           ? const Center(
            //               child: Text('No image selected.'),
            //             )
            //           : Image.file(_image!),
            // ),
            Center(
              child: Visibility(
                visible: textToShow != null,
                child: Text(
                  "總顆數:$total\n白頭粉刺總數:$count1\n黑頭粉刺總數:$count2\n丘疹總數:$count3\n膿泡總數:$count4\n結節總數:$count5\n囊腫總數:$count6",
                  maxLines: 7,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: runObjectDetectionInCamera,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              icon: const Icon(Icons.photo_camera, size: 20),
              label: const Text('使用相機'),
            ),
            TextButton.icon(
              onPressed: runObjectDetectionInGallery,
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              icon: const Icon(Icons.image, size: 20),
              label: const Text('使用相簿'),
            ),
            // Center(
            //   child: Visibility(
            //     visible: _prediction != null,
            //     child: Text(_prediction != null ? "${_prediction![0]}" : ""),
            //   ),
            // )
          ],
        ),
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
                onPressed: () =>
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) {
                    return const SelectMode();
                  },
                ), (route) => false),
              )
            ],
          ),
        );
        return shouldPop ?? false;
      },
    );
  }
}
