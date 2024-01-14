import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authentication/screens/signin_screen.dart';
import 'person_page/screens/personal_information.dart';

Drawer drawer(BuildContext context, String name) {
  final user = FirebaseAuth.instance.currentUser!;

  // Widget smallIMG(Image image) {
  //   return Container(
  //     width: 100,
  //     height: 100,
  //     child: image,
  //   );
  // }
  //
  // Widget bigIMG(Image image) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     child: image,
  //   );
  // }
  //
  // void full_imgPage(BuildContext context, Image image) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => Scaffold(
  //         appBar: AppBar(
  //           elevation: 0,
  //           backgroundColor: Colors.transparent,
  //           leading: IconButton(
  //             icon: const Icon(
  //               Icons.arrow_back,
  //               color: Colors.white,
  //             ),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ),
  //         backgroundColor: Colors.black,
  //         body: GestureDetector(
  //           child: Container(
  //             child: Center(
  //               child: bigIMG(image),
  //             ),
  //           ),
  //           onTap: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // Image img = Image.asset(
  //   'assets/1.png',
  //   fit: BoxFit.fitWidth,
  // );
  return Drawer(
    child: ListView(
      padding: const EdgeInsets.only(),
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(name),
          accountEmail: Text('${user.email}'),
          currentAccountPicture: const CircleAvatar(
            child: Center(
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 24,
              ),
            ),
            // child: GestureDetector(
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(110),
            //     child: smallIMG(img),
            //   ),
            //   onTap: () {
            //     full_imgPage(context, img);
            //   },
            // ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text(
            '個人資訊',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () async {
            // Navigator.of(context).pop();

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const personal_information(
                    // user_email: '${user.email}',
                    // user_name: name,
                  );
                },
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_hospital_outlined),
          title: const Text(
            '醫院服務',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.history_outlined),
          title: const Text(
            '歷史紀錄',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.book_outlined),
          title: const Text(
            '小知識',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {},
          // onTap: () async {
          //
          //   Navigator.of(context).pop();
          //
          //   await Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) {
          //         return const Acnelibrary();
          //       },
          //     ),
          //   );
          // },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text(
            '使用說明',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.output,
            color: Colors.red,
          ),
          title: const Text(
            '登出',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          onTap: () async {
            FirebaseAuth.instance.signOut().then(
              (value) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                    (route) => false);
              },
            );
          },
        ),
      ],
    ),
  );
}
