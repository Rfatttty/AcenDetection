// ignore_for_file: depend_on_referenced_packages, camel_case_types, non_constant_identifier_names

import 'dart:async';
import 'package:acne_camera/customPainter.dart';
import 'package:acne_camera/selectModel.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../back_camera/leftface_cameraPage.dart';
import '../back_camera/middleface_cameraPage.dart';
import 'middleface_cameraPage.dart';

class leftface_frontcameraPage extends StatefulWidget {
  const leftface_frontcameraPage(
      {Key? key,
      required this.cameras,
      required this.username,
      required this.recordname})
      : super(key: key);

  final List<CameraDescription>? cameras;
  final String username;
  final String recordname;

  @override
  leftface_frontcameraPageState createState() =>
      leftface_frontcameraPageState();
}

class leftface_frontcameraPageState extends State<leftface_frontcameraPage> {
  late CameraController _controller;
  final user = FirebaseAuth.instance.currentUser!;

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
    initCamera(widget.cameras![1]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftface_camerabody = Transform.scale(
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

    // FutureBuilder<void>(
    //   future: _initializeControllerFuture,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       return CameraPreview(
    //         _controller,
    //       );
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );

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
                          '${widget.recordname}-${widget.username}-${recordTime}-1.jpg',
                        );

                        final leftfaceimage = await _controller.takePicture();
                        print(stopwatch.elapsedMilliseconds);

                        await _controller.setFocusMode(FocusMode.auto);
                        await _controller.setExposureMode(ExposureMode.auto);

                        leftfaceimage.saveTo(path);
                        print(stopwatch.elapsedMilliseconds);

                        if (!mounted) return;

                        // await availableCameras().then(
                        //       (value) => Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //       builder: (_) => middleface_frontcameraPage(
                        //         cameras: value,
                        //         username: widget.username,
                        //         recordname: widget.recordname, image1: leftfaceimage,
                        //       ),
                        //     ),
                        //   ),
                        // );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => middleface_frontcameraPage(
                              cameras: widget.cameras,
                              username: widget.username,
                              recordname: widget.recordname,
                              image1: leftfaceimage,
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
                      builder: (context) => leftface_backcameraPage(
                          cameras: widget.cameras,
                          username: widget.username,
                          recordname: widget.recordname),
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('採集左臉'),
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
          children: [leftface_camerabody, painter, frontbackChange_btn],
        ),
      ),
    );
  }
}