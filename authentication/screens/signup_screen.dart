import 'package:acne_camera/authentication/screens/signin_screen.dart';
import 'package:acne_camera/authentication/widgets/reusable_widget.dart';
import 'package:acne_camera/selectModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/user.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.blue[300],
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      'assets/NTUT_TMU.png',
                      height: 250,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      '您好\n歡迎您的加入',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextFiled('Enter User Name', '',
                        Icons.person_outline, false, _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextFiled('Enter Email ID', 'xxx@example.com',
                        Icons.email_outlined, false, _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    visibilityTextFiled(
                      'Enter Password',
                      'Be at least 8 characters long',
                      Icons.lock_outline,
                      _obscureText,
                      true,
                      _passwordTextController,
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    signInSignUpButton(
                      context,
                      false,
                      () async {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then(
                          (value) async {
                            createUser(
                                username: _userNameTextController.text,
                                useremail: _emailTextController.text,
                                password: _passwordTextController.text);

                            showDialog(
                              // The user CANNOT close this dialog  by pressing outsite it
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return const Dialog(
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
                                );
                              },
                            );

                            await Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                Navigator.of(context).pop();

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );
                              },
                            );

                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => const SelectMode(),
                            //   ),
                            // );

                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => const SignInScreen(),
                            //   ),
                            // );
                          },
                        ).onError(
                          (error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      // error.toString(),
                                      '輸入錯誤\n請重新檢查您的信箱和密碼',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                                shape: StadiumBorder(),
                                margin: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                behavior: SnackBarBehavior.floating,
                                elevation: 0,
                              ),
                            );
                            print("Error ${error.toString}");
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Have an account?  ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                // onPressed: () => Navigator.pop(context, true),
                onPressed: () => SystemNavigator.pop(),
              )
            ],
          ),
        );
        return shouldPop ?? false;
      },
    );
  }
}
