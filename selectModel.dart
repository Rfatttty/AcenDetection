import 'package:acne_camera/authentication/widgets/user.dart';
import 'package:acne_camera/pytorch/run_model_by_image_demo.dart';
import 'package:acne_camera/pytorch/run_model_by_mulityimage_demo.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'camera_page/first-take/back_camera/leftface_cameraPage.dart';
import 'drawer.dart';
import 'package:logger/logger.dart';

class SelectMode extends StatefulWidget {
  const SelectMode({Key? key}) : super(key: key);

  @override
  SelectModeScreen createState() => SelectModeScreen();
}

class SelectModeScreen extends State<SelectMode> {
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final List<XFile>? imagesList = [];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.bottom]); //隱藏APP下方工具列

    return FutureBuilder(
      future: readUser(useremail: '${user.email}'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userdata = snapshot.data;
          return user == null
              ? const Center(
                  child: Text('No User'),
                )
              : WillPopScope(
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text(
                        'Acne_camera by Lab321',
                      ),
                    ),
                    drawer: drawer(context, '${userdata.name}'),
                    body: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  title: const Text('請輸入採集編號'),
                                  content: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: '請輸入編號',
                                          hintText: '',
                                          prefixIcon: Icon(Icons.person),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.blue),
                                          ),
                                        ),
                                        controller: controller,
                                        obscureText: false,
                                        validator: (value) {
                                          // return value!.trim().isNotEmpty ? null : '編號不得為空';
                                          if (value!.trim().isEmpty) {
                                            return '編號不得為空';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text(
                                        '返回',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await availableCameras().then(
                                            (value) =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    leftface_backcameraPage(
                                                  cameras: value,
                                                  username: controller.text,
                                                  recordname:
                                                      '${userdata.name}',
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('數據採集'),
                                    ),
                                  ],
                                ),
                              ),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          ' 採集模式',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RunModelByImageDemo(),
                                  ),
                                );
                                // showCustomDialog<bool>(
                                //   context: context,
                                //   builder: (context) {
                                //     return AlertDialog(
                                //       title: const Text("模型檢測"),
                                //       content: const Text("該功能尚在開發中..."),
                                //       actions: <Widget>[
                                //         TextButton(
                                //           child: const Text("返回"),
                                //           // onPressed: () => Navigator.of(context).pop(),
                                //           onPressed: () =>
                                //               Navigator.of(context).pop(),
                                //         ),
                                //       ],
                                //     );
                                //   },
                                // );
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Icon(
                                          Icons.android,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          ' 模型檢驗',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            GestureDetector(
                              onTap: () async {


                                showDialog(
                                  context: this.context,
                                  barrierDismissible: false, // 點擊dialog外部區域不會關閉dialog
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          CircularProgressIndicator(),
                                          SizedBox(height: 10),
                                          Text("圖片載入中..."),
                                        ],
                                      ),
                                    );
                                  },
                                );

                                List<XFile> images =
                                    await ImagePicker().pickMultiImage();

                                setState(() {
                                  Navigator.of(this.context).pop(); // 关闭dialog
                                });

                                print("selected ${images.length} images");


                                if (images.length <= 3) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RunModelByMultiImageDemo(
                                        images: images,
                                      ),
                                    ),
                                  );
                                } else if (3 < images.length) {
                                  Fluttertoast.showToast(
                                    msg: "您選擇了${images.length}張，僅顯示前三張",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black54,
                                    textColor: Colors.white,
                                    fontSize: 18.0,
                                  );
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () {
                                      Fluttertoast.cancel();
                                    },
                                  );

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RunModelByMultiImageDemo(
                                        images: images.sublist(0, 3),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Icon(
                                          Icons.face,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          ' 複數辨識',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onWillPop: () async {
                    final shouldPop = await showDialog<bool?>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          '您是否要關閉應用程式',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('CANCEL'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: const Text('YES'),
                            onPressed: () => Navigator.pop(context, true),
                          )
                        ],
                      ),
                    );
                    return shouldPop ?? false;
                  },
                );
        } else {
          {
            // return const Center(
            //   child: CircularProgressIndicator(),
            // );
            return Container(
              color: Colors.white, //
              child: const Center(
                child: Dialog(
                  backgroundColor: Colors.white,
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // The loading indicator
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 15,
                            ),
                            // Some text
                            Text('Loading...')
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
