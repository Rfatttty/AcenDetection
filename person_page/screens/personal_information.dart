// ignore_for_file: camel_case_types, avoid_print

import 'package:acne_camera/selectModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../authentication/widgets/user.dart';
import '../widgets/reusable_widget.dart';

class personal_information extends StatefulWidget {
  const personal_information({super.key});

  @override
  personal_informationState createState() => personal_informationState();
}

class personal_informationState extends State<personal_information> {
  final user = FirebaseAuth.instance.currentUser!;
  final List<String> list = <String>['男性', '女性', '其他'];
  String dropdownValue = '男性';

  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _userEmailTextController =
      TextEditingController();
  final TextEditingController _userRocIDTextController =
      TextEditingController();
  final TextEditingController _userGenderTextController =
      TextEditingController();
  final TextEditingController _userBirthTextController =
      TextEditingController();
  final TextEditingController _userPhoneTextController =
      TextEditingController();
  final TextEditingController _userPhone2TextController =
      TextEditingController();
  final TextEditingController _emergencyNameTextController =
      TextEditingController();
  final TextEditingController _emergencyPhoneTextController =
      TextEditingController();
  final TextEditingController _emergencyPhone2TextController =
      TextEditingController();
  final TextEditingController _remarkTextController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
                      title: const Text('個人資料'),
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '使用者帳號',
                            _userEmailTextController
                              ..text = '${userdata.email}(不可更改)',
                            false,
                            1,
                            TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '使用者名稱',
                            _userNameTextController..text = '${userdata.name}',
                            true,
                            1,
                            TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          genderFormField(
                            dropdownValue,
                            _userGenderTextController,
                          ),
                          // customtextFiled(
                          //   '性別',
                          //   _userGenderTextController,
                          //   true,
                          //   1,
                          //   TextInputType.text,
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '身分證字號',
                            _userRocIDTextController,
                            true,
                            1,
                            TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DateTimetextFiled(
                            context,
                            '生日',
                            _userBirthTextController,
                            true,
                            1,
                            () async {
                              DateTime? pickdate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (pickdate != null) {
                                setState(() {
                                  _userBirthTextController.text =
                                      pickdate.toString().split(' ')[0];
                                });
                              }

                              // showDatePicker(
                              //   context: context,
                              //   initialDate: DateTime.now(),
                              //   firstDate: DateTime(1900),
                              //   lastDate: DateTime(2100),
                              // ).then((value) => () {
                              //       setState(() {
                              //         _userBirthTextController.text = value.toString();
                              //       });
                              //     });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '連絡電話',
                            _userPhoneTextController,
                            true,
                            1,
                            TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '連絡電話(備用)',
                            _userPhone2TextController,
                            true,
                            1,
                            TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '緊急連絡人',
                            _emergencyNameTextController,
                            true,
                            1,
                            TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '緊急連絡電話',
                            _emergencyPhoneTextController,
                            true,
                            1,
                            TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '緊急連絡電話(備用)',
                            _emergencyPhone2TextController,
                            true,
                            1,
                            TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          customtextFiled(
                            '備註',
                            _remarkTextController,
                            true,
                            1,
                            TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  print('使用者帳號：${_userNameTextController.text}');
                                  print('使用者名稱：${_userEmailTextController.text!= '' ? _userEmailTextController.text : 'Null'}');
                                  print('性別：${_userGenderTextController.text!= '' ? _userGenderTextController.text : 'Null'}');
                                  print('身分證字號：${_userRocIDTextController.text!= '' ? _userRocIDTextController.text : 'Null'}');
                                  print('生日：${_userBirthTextController.text!= '' ? _userBirthTextController.text : 'Null'}');
                                  print('連絡電話：${_userPhoneTextController.text!= '' ? _userPhoneTextController.text : 'Null'}');
                                  print('連絡電話(備用)：${_userPhone2TextController.text!= '' ? _userPhone2TextController.text : 'Null'}');
                                  print('緊急連絡人：${_emergencyNameTextController.text!= '' ? _emergencyNameTextController.text : 'Null'}');
                                  print('緊急連絡電話：${_emergencyPhoneTextController.text!= '' ? _emergencyPhoneTextController.text : 'Null'}');
                                  print('緊急連絡電話(備用)：${_emergencyPhone2TextController.text!= '' ? _emergencyPhone2TextController.text : 'Null'}');
                                  print('備註：${_remarkTextController.text != '' ? _remarkTextController.text : 'Null'}');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  '更新',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      _userEmailTextController.clear();
                                      _userRocIDTextController.clear();
                                      _userGenderTextController.clear();
                                      _userBirthTextController.clear();
                                      _userPhoneTextController.clear();
                                      _userPhone2TextController.clear();
                                      _emergencyNameTextController.clear();
                                      _emergencyPhoneTextController.clear();
                                      _emergencyPhone2TextController.clear();
                                      _remarkTextController.clear();
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  '清除',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
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
                            child: const Text(
                              'YES',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () =>
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const SelectMode(),
                                    ),
                                    (route) => false),
                          )
                        ],
                      ),
                    );
                    return shouldPop ?? false;
                  },
                );
        } else {
          {
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
