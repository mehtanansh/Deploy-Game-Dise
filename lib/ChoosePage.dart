import 'package:flutter/material.dart';
import 'package:gamedise/MainScorePage.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/sudoku/SudokuMainPage.dart';
import 'package:gamedise/tictactoe/TicTacToeMainPage.dart';

class ChoosePage extends StatefulWidget {
  static const routeName = '/ChoosePage';
  final PlayerInfo user;
  ChoosePage({this.user});
  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  PlayerInfo player;

  @override
  Widget build(BuildContext context) {
    player = ModalRoute.of(context).settings.arguments == null
        ? widget.user
        : ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
          decoration: background(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                          elevation: 15.0,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(100.0)),
                          textColor: Colors.white,
                          color: Color(0xFF14D0FF),
                          splashColor: Colors.tealAccent,
                          child: Text(
                            "SUDOKU",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SudokuMainPage.routeName,
                                arguments: player);
                          }),
                      padding: const EdgeInsets.all(16),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                          elevation: 15.0,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(100.0)),
                          textColor: Colors.white,
                          color: Color(0xFF14D0FF),
                          splashColor: Colors.tealAccent,
                          child: Text(
                            "TIC TAC TOE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, TicTacToeMainPage.routeName,
                                arguments: player);
                          }),
                      padding: const EdgeInsets.all(16),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                      alignment: Alignment.center,
                      child: MaterialButton(
                          elevation: 15.0,
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(100.0)),
                          textColor: Colors.white,
                          color: Color(0xFF14D0FF),
                          splashColor: Colors.tealAccent,
                          child: Text(
                            "ScoreBoard",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, MainScorePage.routeName,
                                arguments: player);
                          }),
                      padding: const EdgeInsets.all(16),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
