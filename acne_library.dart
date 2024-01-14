import 'package:acne_camera/selectModel.dart';
import 'package:flutter/material.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';

class Acnelibrary extends StatefulWidget {
  const Acnelibrary({super.key});

  @override
  AcnelibraryState createState() => AcnelibraryState();
}

class AcnelibraryState extends State<Acnelibrary> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('種類介紹'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Colors.green[200],
        body: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: RoundedExpansionTile(
                leading: const Icon(Icons.person),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: const Text('類別一'),
                subtitle: const Text('類別一(補充說明)'),
                trailing: const Icon(Icons.keyboard_arrow_down_rounded),
                rotateTrailing: true,
                children: [
                  Column(
                    children: [
                      RoundedExpansionTile(
                        leading: const Icon(Icons.list),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        title: const Text('Category 1'),
                        children: [
                          Column(
                            children: [
                              ListTile(
                                title: const Text('Category 1-1'),
                                onTap: () {},
                              ),
                              ListTile(
                                title: const Text('Category 1-2'),
                                onTap: () {},
                              )
                            ],
                          )
                        ],
                      ),
                      ListTile(
                        title: const Text('Category 2'),
                        onTap: () {},
                      )
                    ],
                  )
                ],
              ),
            ),
            const Divider(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: RoundedExpansionTile(
                leading: const Icon(Icons.person),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: const Text('類別二'),
                subtitle: const Text('類別二(補充說明)'),
                children: [
                  Column(
                    children: [
                      RoundedExpansionTile(
                        leading: const Icon(Icons.person),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        title: const Text('Category 1'),
                        children: [
                          Column(
                            children: [
                              ListTile(
                                title: const Text('Category 1-1'),
                                onTap: () {},
                              ),
                              ListTile(
                                title: const Text('Category 1-2'),
                                onTap: () {},
                              )
                            ],
                          )
                        ],
                      ),
                      ListTile(
                        title: const Text('Category 2'),
                        onTap: () {},
                      )
                    ],
                  )
                ],
              ),
            ),
            const Divider(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: RoundedExpansionTile(
                leading: const Icon(Icons.person),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: const Text('類別三'),
                subtitle: const Text('類別三(補充說明)'),
                children: [
                  Column(
                    children: [
                      RoundedExpansionTile(
                        leading: const Icon(Icons.person),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        title: const Text('Category 1'),
                        children: [
                          Column(
                            children: [
                              ListTile(
                                title: const Text('Category 1-1'),
                                onTap: () {},
                              ),
                              ListTile(
                                title: const Text('Category 1-2'),
                                onTap: () {},
                              )
                            ],
                          )
                        ],
                      ),
                      ListTile(
                        title: const Text('Category 2'),
                        onTap: () {},
                      )
                    ],
                  )
                ],
              ),
            ),
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
