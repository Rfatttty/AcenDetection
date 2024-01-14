// import 'dart:async';
// import 'package:acne_camera/customPainter.dart';
// import 'package:acne_camera/data/data.dart';
// import 'package:acne_camera/selectModel.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'display_picture.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
//
// class rightface_camera extends StatefulWidget {
//   const rightface_camera({Key? key, required this.cameras}) : super(key: key);
//
//   final List<CameraDescription>? cameras;
//
//   @override
//   rightface_cameraState createState() => rightface_cameraState();
// }
//
// class rightface_cameraState extends State<rightface_camera> {
//   late CameraController _controller;
//
//   Future initCamera(CameraDescription cameraDescription) async {
//     _controller = CameraController(cameraDescription, ResolutionPreset.high);
//     try {
//       await _controller.initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//       });
//     } on CameraException catch (e) {
//       debugPrint("camera error $e");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initCamera(widget.cameras![0]);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Username data = ModalRoute.of(context)!.settings.arguments as Username;
//     String userNumber = data.number;
//
//     final rightface_camerabody = SafeArea(
//       child: Stack(
//         children: [
//           (_controller.value.isInitialized)
//               ? CameraPreview(_controller)
//               : Container(
//                   color: Colors.black,
//                   child: const Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//         ],
//       ),
//     );
//
//     final painter = Center(
//       child: FittedBox(
//         child: SizedBox(
//           child: CustomPaint(
//             size: Size(MediaQuery.of(context).size.width,
//                 MediaQuery.of(context).size.height),
//             painter: Painter(),
//           ),
//         ),
//       ),
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('採集右臉'),
//         leading: IconButton(
//           onPressed: () async {
//             await availableCameras().then(
//               (value) => Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const SelectMode(),
//                   ),
//                   (route) => false),
//             );
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: Stack(
//         children: [rightface_camerabody, painter],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (!_controller.value.isInitialized) {
//             return;
//           }
//           if (_controller.value.isTakingPicture) {
//             return;
//           }
//           try {
//             await _controller.setFlashMode(FlashMode.off);
//
//             final path = join(
//               // Store the picture in the temp directory.
//               // Find the temp directory using the `path_provider` plugin.
//               (await getTemporaryDirectory()).path,
//               '${userNumber}-3.jpg',
//             );
//
//             final rightfaceimage = await _controller.takePicture();
//             rightfaceimage.saveTo(path);
//
//             await GallerySaver.saveImage(path);
//
//             if (!mounted) return;
//
//             await availableCameras().then(
//               (value) => Navigator.pushNamed(context, '/DisplayPictureScreen',
//                   arguments: RightfacecameraData(path)),
//             );
//
//             // await Navigator.of(context).push(
//             //   MaterialPageRoute(
//             //     builder: (context) => DisplayPictureScreen(
//             //       camera: widget.camera,
//             //       leftfaceimagePath: widget.leftfaceimagePath,
//             //       middlefaceimagePath: widget.middlefaceimagePath,
//             //       rightfaceimagePath: path,
//             //     ),
//             //   ),
//             // );
//           } catch (e) {
//             print(e);
//           }
//         },
//         tooltip: '拍照',
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }

// ignore_for_file: depend_on_referenced_packages, camel_case_types

import 'dart:async';
import 'package:acne_camera/customPainter.dart';
import 'package:acne_camera/selectModel.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:acne_camera/display_picture.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../front_camera/rightface_cameraPage.dart';

class rightface_backcameraPage extends StatefulWidget {
  const rightface_backcameraPage({
    Key? key,
    required this.cameras,
    required this.username,
    required this.recordname,
    required this.image1,
    required this.image2,
  }) : super(key: key);

  final List<CameraDescription>? cameras;
  final String username;
  final String recordname;
  final XFile image1;
  final XFile image2;

  @override
  rightface_backcameraPageState createState() =>
      rightface_backcameraPageState();
}

class rightface_backcameraPageState extends State<rightface_backcameraPage> {
  late CameraController _controller;

  Future initCamera(CameraDescription cameraDescription) async {
    _controller =
        CameraController(cameraDescription, ResolutionPreset.veryHigh);
    try {
      await _controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rightface_camerabody = Transform.scale(
      scale: 1.0,
      child: SafeArea(
        child: Stack(
          children: [
            (_controller.value.isInitialized)
                ? CameraPreview(_controller)
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );

    final frontbackChange_btn = SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 620,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // children: [SizedBox(),SizedBox(), btn002],
            children: [
              const SizedBox(
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                height: 80,
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: () async {
                      try {
                        final stopwatch = Stopwatch();
                        stopwatch.start();

                        await _controller.setFocusMode(FocusMode.locked);
                        await _controller.setExposureMode(ExposureMode.locked);
                        await _controller.setFlashMode(FlashMode.off);
                        print(stopwatch.elapsedMilliseconds);

                        String now = DateTime.now().toString();
                        List time1 = now.split(' ')[0].split('-');
                        List time2 = now.split(' ')[1].split(':');
                        List time3 = time2[2].split('.');
                        String recordTime =
                            '${time1[0]}-${time1[1]}-${time1[2]}-${time2[0]}-${time2[1]}-${time3[0]}';

                        final path = join(
                          // Store the picture in the temp directory.
                          // Find the temp directory using the `path_provider` plugin.
                          (await getTemporaryDirectory()).path,
                          '${widget.recordname}-${widget.username}-${recordTime}-3.jpg',
                        );

                        final rightfaceimage = await _controller.takePicture();
                        print(stopwatch.elapsedMilliseconds);

                        await _controller.setFocusMode(FocusMode.auto);
                        await _controller.setExposureMode(ExposureMode.auto);

                        rightfaceimage.saveTo(path);
                        print(stopwatch.elapsedMilliseconds);

                        if (!mounted) return;

                        // await availableCameras().then(
                        //   (value) => Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (_) => DisplayPictureScreen(
                        //         // camera: value[0],
                        //         username: widget.username,
                        //         recordname: widget.recordname,
                        //         image1: widget.image1,
                        //         image2: widget.image2,
                        //         image3: rightfaceimage,
                        //       ),
                        //     ),
                        //   ),
                        // );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DisplayPictureScreen(
                              // camera: value[0],
                              username: widget.username,
                              recordname: widget.recordname,
                              image1: widget.image1,
                              image2: widget.image2,
                              image3: rightfaceimage,
                            ),
                          ),
                        );

                        print(stopwatch.elapsedMilliseconds);

                        stopwatch.stop();
                        stopwatch.reset();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => rightface_frontcameraPage(
                        cameras: widget.cameras,
                        username: widget.username,
                        recordname: widget.recordname,
                        image1: widget.image1,
                        image2: widget.image2,
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.blue,
                child: const Icon(
                  Icons.cameraswitch_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              )
            ],
          )
        ],
      ),
    );

    final painter = Center(
      child: FittedBox(
        child: SizedBox(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: RightfacePainter(),
          ),
        ),
      ),
    );

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('採集右臉'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              await availableCameras().then(
                (value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectMode(),
                    ),
                    (route) => false),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Stack(
          children: [rightface_camerabody, painter, frontbackChange_btn],
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
