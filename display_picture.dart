import 'dart:io';
import 'package:acne_camera/camera_page/re-take/back_camera/re_leftface_cameraPage.dart';
import 'package:acne_camera/camera_page/re-take/back_camera/re_middleface_cameraPage.dart';
import 'package:acne_camera/camera_page/re-take/back_camera/re_rightface_cameraPage.dart';
import 'package:acne_camera/pytorch/run_model_by_mulityimage_demo.dart';
import 'package:acne_camera/selectModel.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({
    Key? key,
    // required this.camera,
    required this.username,
    required this.recordname,
    required this.image1,
    required this.image2,
    required this.image3,
  }) : super(key: key);

  // final CameraDescription camera;
  final String username;
  final String recordname;
  final XFile image1;
  final XFile image2;
  final XFile image3;

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  var isDialOpen = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final img1 = Image.file(
      File(widget.image1.path),
      alignment: Alignment.topCenter,
    );
    final img2 = Image.file(
      File(widget.image2.path),
      alignment: Alignment.topCenter,
    );
    final img3 = Image.file(
      File(widget.image3.path),
      alignment: Alignment.topCenter,
    );

    Future<bool> saveImage() async {
      // final path1 = join(
      //   (await getTemporaryDirectory()).path,
      //   '${widget.recordname}-${widget.username}-$recordTime-1.jpg',
      // );
      //
      // final path2 = join(
      //   (await getTemporaryDirectory()).path,
      //   '${widget.recordname}-${widget.username}-$recordTime-2.jpg',
      // );
      //
      // final path3 = join(
      //   (await getTemporaryDirectory()).path,
      //   '${widget.recordname}-${widget.username}-$recordTime-3.jpg',
      // );
      //
      // widget.image1.saveTo(path1);
      // widget.image2.saveTo(path2);
      // widget.image3.saveTo(path3);
      //
      // await GallerySaver.saveImage(path1);
      // await GallerySaver.saveImage(path2);
      // await GallerySaver.saveImage(path3);

      try {
        if (!Directory("/storage/emulated/0/Pictures/Acen").existsSync()) {
          Directory("/storage/emulated/0/Pictures/Acen/")
              .createSync(recursive: true);
        }
        if (Directory("/storage/emulated/0/Pictures/Acen").existsSync()) {
          String now = DateTime.now().toString();
          List time1 = now.split(' ')[0].split('-');
          List time2 = now.split(' ')[1].split(':');
          List time3 = time2[2].split('.');
          String recordTime =
              '${time1[0]}-${time1[1]}-${time1[2]}-${time2[0]}-${time2[1]}-${time3[0]}';

          String fileName =
              "${widget.recordname}-${widget.username}-$recordTime";

          File(widget.image1.path)
              .copySync("/storage/emulated/0/Pictures/Acen/$fileName-1.jpg");
          File(widget.image2.path)
              .copySync("/storage/emulated/0/Pictures/Acen/$fileName-2.jpg");
          File(widget.image3.path)
              .copySync("/storage/emulated/0/Pictures/Acen/$fileName-3.jpg");

          Fluttertoast.showToast(
            msg: "Image saved to /Pictures/Acen !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 18.0,
          );
          Future.delayed(
            const Duration(milliseconds: 2500),
            () {
              Fluttertoast.cancel();
            },
          );
        } else {
          Fluttertoast.showToast(
            msg: "/Pictures/Acen folder not found!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 18.0,
          );
          Future.delayed(const Duration(milliseconds: 1000), () {
            Fluttertoast.cancel();
          });
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Image saved to /Pictures/Acen failed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 18.0,
        );
        Future.delayed(const Duration(milliseconds: 1000), () {
          Fluttertoast.cancel();
        });
      }

      // Fluttertoast.showToast(
      //   msg: '相片已儲存到這個裝置',
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.black54,
      //   textColor: Colors.white,
      //   fontSize: 18.0,
      // );
      //
      // await Future.delayed(
      //   const Duration(seconds: 3),
      // );

      return true;
    }

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool?>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Center(
              child: Text(
                '您是否已經儲存照片',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  '我還沒儲存照片',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text(
                  '我已經儲存照片',
                  style: TextStyle(color: Colors.blue),
                ),
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
          title: const Text('照片預覽'),
          centerTitle: true,
          leading: null,
          actions: [
            IconButton(
              icon: const Icon(Icons.face),
              onPressed: () {
                List<XFile> imagelist = [
                  widget.image1,
                  widget.image2,
                  widget.image3
                ];

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RunModelByMultiImageDemo(
                      images: imagelist,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Swiper.children(
              loop: false,
              index: 1,
              containerHeight: MediaQuery.of(context).size.height,
              containerWidth: MediaQuery.of(context).size.width,
              scrollDirection: Axis.horizontal,
              autoplay: false,
              itemHeight: MediaQuery.of(context).size.height * 0.12,
              pagination: const SwiperPagination(
                margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 80.0),
                builder: DotSwiperPaginationBuilder(
                    color: Colors.white70,
                    activeColor: Colors.blue,
                    size: 10.0,
                    activeSize: 15.0),
              ),
              children: <Widget>[img1, img2, img3],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 650,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      child: const Icon(
                        Icons.refresh_sharp,
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Center(
                              child: Text('請選擇您要重新採集的部位'),
                            ),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Center(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();

                                        await availableCameras().then(
                                          (value) => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  re_leftface_backcameraPage(
                                                cameras: value,
                                                username: widget.username,
                                                recordname: widget.username,
                                                image2: widget.image2,
                                                image3: widget.image3,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('採集左臉'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();

                                        await availableCameras().then(
                                          (value) => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  re_middleface_backcameraPage(
                                                cameras: value,
                                                username: widget.username,
                                                recordname: widget.username,
                                                image1: widget.image1,
                                                image3: widget.image3,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('採集正臉'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();

                                        await availableCameras().then(
                                          (value) => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  re_rightface_backcameraPage(
                                                cameras: value,
                                                username: widget.username,
                                                recordname: widget.username,
                                                image1: widget.image1,
                                                image2: widget.image2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('採集右臉'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 170,
                    ),
                    FloatingActionButton(
                      child: const Icon(
                        Icons.download_sharp,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return FutureBuilder(
                              future: saveImage(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return AlertDialog(
                                    title: const Text('Saving'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text('儲存中...'),
                                      ),
                                    ],
                                  );
                                } else {
                                  return AlertDialog(
                                    title: const Text('儲存完畢'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const SelectMode(),
                                            ),
                                          );
                                        },
                                        child: const Text('完成'),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              ],
            )
          ],
        ),

        // SpeedDial(
        //   animatedIcon: AnimatedIcons.menu_close,
        //   closeManually: false,
        //   spacing: 12,
        //   spaceBetweenChildren: 12,
        //   backgroundColor: Colors.blue,
        //   overlayColor: Colors.white,
        //   overlayOpacity: 0.50,
        //   children: [
        //     SpeedDialChild(
        //       child: const Icon(
        //         Icons.refresh,
        //         color: Colors.white,
        //       ),
        //       label: '重新採集(全部)',
        //       labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
        //       labelBackgroundColor: Colors.blue,
        //       backgroundColor: Colors.blue,
        //       onTap: () async {
        //         Navigator.of(context).pushReplacement(
        //           MaterialPageRoute(
        //             builder: (_) => const SelectMode(),
        //           ),
        //         );
        //       },
        //     ),
        //     SpeedDialChild(
        //       child: const Icon(
        //         Icons.refresh,
        //         color: Colors.white,
        //       ),
        //       label: '重新採集(部分)',
        //       labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
        //       labelBackgroundColor: Colors.blue,
        //       backgroundColor: Colors.blue,
        //       onTap: () async {
        //         showDialog(
        //           context: context,
        //           builder: (context) => AlertDialog(
        //             title: const Center(
        //               child: Text('請選擇您要重新採集的部位'),
        //             ),
        //             content: SizedBox(
        //               height: MediaQuery.of(context).size.height * 0.2,
        //               width: MediaQuery.of(context).size.width * 0.9,
        //               child: Center(
        //                 child: Column(
        //                   children: [
        //                     ElevatedButton(
        //                       onPressed: () async {
        //                         Navigator.of(context).pop();
        //
        //                         await availableCameras().then(
        //                           (value) => Navigator.of(context).push(
        //                             MaterialPageRoute(
        //                               builder: (_) =>
        //                                   re_leftface_backcameraPage(
        //                                 cameras: value,
        //                                 username: widget.username,
        //                                 middlefacePath: widget.middlefacePath,
        //                                 rightfacePath: widget.rightfacePath,
        //                                 recordname: widget.username,
        //                               ),
        //                             ),
        //                           ),
        //                         );
        //                       },
        //                       child: const Text('採集左臉'),
        //                     ),
        //                     ElevatedButton(
        //                       onPressed: () async {
        //                         Navigator.of(context).pop();
        //
        //                         await availableCameras().then(
        //                           (value) => Navigator.of(context).push(
        //                             MaterialPageRoute(
        //                               builder: (_) =>
        //                                   re_middleface_backcameraPage(
        //                                 cameras: value,
        //                                 username: widget.username,
        //                                 leftfacePath: widget.leftfacePath,
        //                                 rightfacePath: widget.rightfacePath,
        //                                 recordname: widget.username,
        //                               ),
        //                             ),
        //                           ),
        //                         );
        //                       },
        //                       child: const Text('採集正臉'),
        //                     ),
        //                     ElevatedButton(
        //                       onPressed: () async {
        //                         Navigator.of(context).pop();
        //
        //                         await availableCameras().then(
        //                           (value) => Navigator.of(context).push(
        //                             MaterialPageRoute(
        //                               builder: (_) =>
        //                                   re_rightface_backcameraPage(
        //                                 cameras: value,
        //                                 username: widget.username,
        //                                 leftfacePath: widget.leftfacePath,
        //                                 middlefacePath: widget.middlefacePath,
        //                                 recordname: widget.username,
        //                               ),
        //                             ),
        //                           ),
        //                         );
        //                       },
        //                       child: const Text('採集右臉'),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //     SpeedDialChild(
        //       child: const Icon(
        //         Icons.download_rounded,
        //         color: Colors.white,
        //       ),
        //       label: '下載',
        //       labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
        //       labelBackgroundColor: Colors.blue,
        //       backgroundColor: Colors.blue,
        //       onTap: () async {
        //         await GallerySaver.saveImage(widget.leftfacePath);
        //         await GallerySaver.saveImage(widget.middlefacePath);
        //         await GallerySaver.saveImage(widget.rightfacePath);
        //
        //         print('左臉路徑：${widget.leftfacePath}');
        //         print('正臉路徑：${widget.middlefacePath}');
        //         print('右臉路徑：${widget.rightfacePath}');
        //
        //         Fluttertoast.showToast(
        //           msg: '相片已儲存到這個裝置',
        //           toastLength: Toast.LENGTH_LONG,
        //           gravity: ToastGravity.BOTTOM,
        //           backgroundColor: Colors.black54,
        //           textColor: Colors.white,
        //           fontSize: 18.0,
        //         );
        //       },
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
