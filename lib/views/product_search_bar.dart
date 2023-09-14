import 'package:flutter/material.dart';
import 'package:fluttershop/services/colors.dart';
import 'package:get/get.dart';

class ProductSearchBar extends StatelessWidget {
  final bool isEnabled;
  final Function(String value) onChanged;
  ProductSearchBar(
      {super.key, required this.isEnabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      enabled: isEnabled,
      onChanged: (value) {
        onChanged(value);
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        suffixIcon: Icon(Icons.search),
        filled: true,
        fillColor: primaryColor.withOpacity(0.1),
        hintText: 'Search',
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 0, color: const Color.fromARGB(255, 255, 255, 255)),
          borderRadius: BorderRadius.circular(50.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 0, color: const Color.fromARGB(255, 255, 255, 255)),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 0, color: const Color.fromARGB(255, 255, 255, 255)),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}

class TextController extends GetxController {
  final text = RxString('');

  void updateText(String newText) {
    text.value = newText;
  }
}
