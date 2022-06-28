import 'package:firebasefirst/pages/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    routes: {
      "/": (context) => const HomePage(),
    },
  ));
}