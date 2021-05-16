import 'dart:ui';
import 'package:flutter/material.dart';


class UserScores extends StatelessWidget {
  static const routeName = '/UserScores';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
                Color(0xFF320A3A),
                Color(0xFF0E7B8B),
              ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Game Over",
            style:TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
            Text("Better Luck Next time or Congratulations",
            style:TextStyle(
              fontSize:10,
              color: Colors.white,
            )),
            Text("Games Played: ",
            style:TextStyle(
              fontSize:15,
              color: Colors.green,
            )),
            Text("Games Won: ",
            style:TextStyle(
              fontSize:15,
              color: Colors.green,
            )),
            Text("Win Ratio: ",
            style:TextStyle(
              fontSize:15,
              color: Colors.green,
            )),
            Text("Let the ratio tend towards 1",
            style:TextStyle(
              fontSize:10,
              color: Colors.yellow,
            )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.home,size:50,color:Colors.black
                ),
                Icon(
                  Icons.refresh,size:50,color:Colors.black
                )
              ],

            ),
          ],
        ),
        ),)
    );
  }
}