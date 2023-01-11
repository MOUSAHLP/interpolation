import 'package:flutter/material.dart';

class Custominput extends StatelessWidget {
  final TextEditingController controller;
  Custominput({super.key, required TextEditingController this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      cursorColor: Colors.greenAccent,
      cursorRadius: const Radius.circular(5),
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent, width: 1),
        ),
      ),
    );
  }
}
