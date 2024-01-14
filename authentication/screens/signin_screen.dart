import 'package:acne_camera/authentication/widgets/reusable_widget.dart';
import 'package:acne_camera/authentication/screens/signup_screen.dart';
import 'package:acne_camera/selectModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.blue[300],
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      '您好\n歡迎您的使用',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextFiled('Enter UserName', 'xxx@example.com',
                        Icons.person_outline, false, _emailTextController),
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
                      true,
                      () async {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then(
                          (value) async {
                            showDialog(
                              // The user CANNOT close this dialog  by pressing outsite it
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    child: const Center(
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

                            print('step 1');

                            await Future.delayed(
                              const Duration(seconds: 4),
                            );

                            Navigator.of(context).pop();

                            print('step 2');

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SelectMode(),
                              ),
                            );

                            // Navigator.of(context).pop();
                          },
                        ).onError(
                          (error, stackTrace) async {
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
                            print('Error ${error.toString()}');
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
                          "Don't have account?  ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
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
