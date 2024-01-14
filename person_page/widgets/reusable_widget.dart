import 'package:flutter/material.dart';

Widget customtextFiled(String labelText, TextEditingController controller,
    bool enabledtype, int maxLines, TextInputType keyboardType) {
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30),
    child: TextFormField(
      controller: controller,
      // style: const TextStyle(color: Colors.black),
      textAlign: TextAlign.left,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        enabled: enabledtype,
        labelText: labelText,
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 3.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
    ),
  );
}

final List<String> list = <String>['男性', '女性', '其他'];

Widget genderFormField(String dropdownValue, TextEditingController controller,) {
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30),
    child: DropdownButtonFormField(
      value: dropdownValue,
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
        onChanged: (String? value) {
            controller.text = value.toString();
        },
      hint: Text('性別'),
      dropdownColor: Colors.white,
      focusColor: Colors.white,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 3.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
    ),
  );
}

Widget DateTimetextFiled(BuildContext context,
    String labelText,
    TextEditingController controller,
    bool enabledtype,
    int maxLines,
    Function onTap) {
  return Padding(
    padding: const EdgeInsets.only(left: 30, right: 30),
    child: TextFormField(
      controller: controller,
      textAlign: TextAlign.left,
      textInputAction: TextInputAction.newline,
      maxLines: maxLines,
      keyboardType: TextInputType.none,
      // onTap: (){
      //   onTap();
      // },
      onTap: () {
        onTap();
      },
      decoration: InputDecoration(
        enabled: enabledtype,
        labelText: labelText,
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.blueAccent,
            width: 3.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
    ),
  );
}
