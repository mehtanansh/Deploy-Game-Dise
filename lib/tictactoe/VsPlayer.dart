import 'package:flutter/material.dart';
import 'package:gamedise/ChoosePage.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/tictactoe/ScorePage.dart';

class VsPlayer extends StatefulWidget {
  static const routeName = '/vsPlayerPage';
  PlayerInfo currentPlayer;
  @override
  State<StatefulWidget> createState() {
    return _VsPlayerState();
  }
}

class _VsPlayerState extends State<VsPlayer> {
  bool playerX = true;
  bool win = false;
  var borderColor = Colors.lightBlue;
  int moveCount = 0;
  int hint;
  int scorePlayerX = 0, scorePlayer0 = 0;
  PlayerInfo player;
  var _matrix = [
    [" ", " ", " "],
    [" ", " ", " "],
    [" ", " ", " "]
  ];

  _initMat({status}){
    status = status==null?false:true;
    if (status) {
      Navigator.popAndPushNamed(context, ScorePage.routeName,
          arguments: player);
    }
    setState(() {
      _matrix = [
        [" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "]
      ];
    });
  }

  String lc = "O";
  String player1Name, player2Name;
  @override
  Widget build(BuildContext context) {
    player = ModalRoute.of(context).settings.arguments;
    player1Name = player.name;
    player2Name = player.player2;
    hint = player.hint;
    setState(() {
      scorePlayer0 = player.loss;
      scorePlayerX = player.wins;
      player.mode = 2;
      player.play = true;
    });
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: background(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    playerScore(player1Name, scorePlayerX),
                    playerScore(player2Name, scorePlayer0),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (lc == "o")
                        ? "$player1Name's Turn \n"
                        : "$player2Name's Turn \n",
                    style:
                        TextStyle(fontSize: 25, color: Colors.amberAccent[400]),
                  ),
                ],
              ),
              ticTacToeBoard(_buildElementBox, player),
              Container(
                width: MediaQuery.of(context).size.width,
                color: borderColor,
                height: 2,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                color: Colors.transparent,
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    homeButton(context, player),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _replay() {
    setState(() {
      _initMat();
    });
  }

  _buildElementBox(int i, int j, PlayerInfo player) {
    return GestureDetector(
      onTap: () async {
        _changeMatFields(i, j);
        if (_checkWinner(i, j)) {
          if (_matrix[i][j] == "x") {
            await setState(() {
              this.scorePlayerX++;
              player.gameWon();
              player.play = false;
            });
          } else if (_matrix[i][j] == "o") {
            await setState(() {
              this.scorePlayer0++;
              player.gameLoss();
                  player.play = false;
            });
          }
          showDialogBox(
              context,
              "Congratulations!! \nPlayer " + _matrix[i][j] + " Won!!",
              player,
              _initMat);
        } else {
          if (_checkDraw()) {
            await setState(() {
              player.gameDraws();
                  player.play = false;
            });
            showDialogBox(
                context, "Match Draw!! \nGreat Game", player, _initMat);
          }
        }
      },
      child: Container(
        width: 96.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: borderCell(i, j), //Border.all(color: Colors.lightBlue)),
        ),
        child: Text(
          _matrix[i][j],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 90, color: Colors.amberAccent[400]),
        ),
      ),
    );
  }

  _changeMatFields(int i, int j) {
    if (_matrix[i][j] == " ") {
      if (lc == "o") {
        setState(() {
          _matrix[i][j] = "x";
          moveCount++;
          lc = "x";
        });
      } else {
        setState(() {
          _matrix[i][j] = "o";
          lc = "o";
          moveCount++;
        });
      }
    }
  }

  _checkWinner(int x, int y) {
    var col1 = 0, row1 = 0, diag1 = 0, rdiag1 = 0;
    var n = 2;
    var playerX0 = _matrix[x][y];
    for (int i = 0; i < 3; i++) {
      if (_matrix[x][i] == playerX0) {
        col1 += 1;
      }
      if (_matrix[i][y] == playerX0) {
        row1 += 1;
      }
      if (_matrix[i][i] == playerX0) {
        diag1 += 1;
      }
      if (_matrix[i][n - i] == playerX0) {
        rdiag1 += 1;
      }
    }
    if (row1 == 3 || col1 == 3 || diag1 == 3 || rdiag1 == 3) {
      return true;
    } else {
      return false;
    }
  }

  _checkDraw() {
    var draw = true;
    _matrix.forEach((i) {
      i.forEach((j) {
        if (j == " ") {
          draw = false;
        }
      });
    });
    return draw;
  }
}
