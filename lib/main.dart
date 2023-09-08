import 'package:flutter/material.dart';
import 'package:music_relu/features/details/ui/details.dart';
import 'package:music_relu/features/music/ui/home.dart';

main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
