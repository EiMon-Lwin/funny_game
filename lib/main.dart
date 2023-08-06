import 'package:flutter/material.dart';
import 'package:funny_game/home_page.dart';

void main(){
  runApp(FunnyGame());

}

class FunnyGame extends StatelessWidget {
  const FunnyGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
