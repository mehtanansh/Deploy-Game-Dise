import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamedise/ChoosePage.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/tictactoe/VsAIHard.dart';
import 'package:gamedise/tictactoe/VsAISimple.dart';
import 'package:gamedise/tictactoe/VsPlayer.dart';

class ScorePage extends StatelessWidget {
  static const routeName = '/ScorePage';
  PlayerInfo player;
  var winRatio;
  @override
  Widget build(BuildContext context) {
    player = ModalRoute.of(context).settings.arguments;
    winRatio = player.totalGamePlayed == 0 ? 0 : player.wins / player.totalGamePlayed;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Tic Tac Toe"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(10.0),
        decoration: background(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Text("Game Over",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                )),
            Text(
                winRatio <= 0.5
                    ? "Better Luck Next time !!"
                    : "Congratulations !!",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Row(
              children: [
                Text("Games Played: ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    )),
                Text("${player.totalGamePlayed}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              children: [
                Text("Games Won: ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    )),
                Text("${player.wins}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              children: [
                Text("Games Loss: ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    )),
                Text("${player.loss}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              children: [
                Text("Games Draw: ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    )),
                Text("${player.draws}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    )),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
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
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Text("Let the ratio tend towards 1",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.yellow,
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: borderColor,
              height: 2,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              color: Colors.transparent,
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  homeButton(context, player),
                  resetBoardButton(context,player, refresh),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  refresh(BuildContext context) async {
    if (player.mode == 0) {
      await player.setGame(0, reset: true);
      Navigator.popAndPushNamed(context, VsAISimple.routeName,
          arguments: player);
    } else if (player.mode == 1) {
      await player.setGame(1, reset: true);
      Navigator.popAndPushNamed(context, VsAIHard.routeName, arguments: player);
    } else {
      player.play = true;
      await player.setGame(2, reset: true);
      Navigator.popAndPushNamed(context, VsPlayer.routeName, arguments: player);
    }
  }
}
