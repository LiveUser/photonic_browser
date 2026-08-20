import 'package:flutter/material.dart';

AppBar appBar(){
  return AppBar(
    title: Text(
      "Photonic Browser",
      style: TextStyle(
        color: Colors.white,
        fontFamily: "BlackOpsOne",
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.deepPurple,
  );
}