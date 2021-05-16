import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';

class MainScorePage extends StatelessWidget {
  static const routeName = '/MainScorePage';
  @override
  Widget build(BuildContext context) {
    PlayerInfo player = ModalRoute.of(context).settings.arguments;
    var winRatio = player.overallTotalGamePlayed == 0
        ? 0
        : player.totalWins == null
            ? 0
            : (player.totalWins / player.overallTotalGamePlayed);
    return Scaffold(
        appBar: AppBar(
          title: Text("ScoreBoard"),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(10.0),
          decoration: background(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${player.name.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  )),
              Row(
                children: [
                  Text("Total Games Played: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      )),
                  Text("${player.overallTotalGamePlayed}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Total Games Won: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      )),
                  Text("${player.totalWins}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Total Games Loss: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      )),
                  Text("${player.totalLoss}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Total Games Draw: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      )),
                  Text("${player.totalDraws}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Win Ratio: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      )),
                  Text(" ${winRatio.toStringAsFixed(4)}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Total Sudoku Played: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                      )),
                  Text("${player.totalSudokuSolved}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}
