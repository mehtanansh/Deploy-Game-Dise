import 'package:flutter/material.dart';
import 'package:gamedise/ChoosePage.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/tictactoe/ScorePage.dart';

class VsAISimple extends StatefulWidget {
  static const routeName = '/VsAISimplePage';
  PlayerInfo currentPlayer;
  @override
  State<StatefulWidget> createState() {
    return _VsAISimpleState();
  }
}

class _VsAISimpleState extends State<VsAISimple> {
  var lc = "o";
  bool playerX = true;
  bool win = false;
  var borderColor = Colors.lightBlue;
  int moveCount = 0;
  int hint;
  int scorePlayerX = 0, scorePlayer0 = 0;
  PlayerInfo player;
  String player1Name;
  String turn = "X's Turn \n";
  var _matrix = [
    [" ", " ", " "],
    [" ", " ", " "],
    [" ", " ", " "]
  ];
  var _dupmat = [
    [" ", " ", " "],
    [" ", " ", " "],
    [" ", " ", " "]
  ];

  _initMat({status}) {
    status = status == null ? false : true;
    if (status) {
      Navigator.popAndPushNamed(context, ScorePage.routeName,
          arguments: player);
    }
    setState(() {
      lc = "o";
      player.hint = 2;
      _matrix = [
        [" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "]
      ];
      _dupmat = [
        [" ", " ", " "],
        [" ", " ", " "],
        [" ", " ", " "]
      ];
      turn = "X's Turn \n";
    });
  }

  @override
  Widget build(BuildContext context) {
    this.player = ModalRoute.of(context).settings.arguments;
    player1Name = player.name;
    hint = player.hint;
    setState(() {
      scorePlayer0 = player.loss;
      scorePlayerX = player.wins;
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
                    playerScore("AI", scorePlayer0),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    turn,
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    homeButton(context, player),
                    hintButton(context, hint, player, _hint),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildElementBox(int i, int j, PlayerInfo player) {
    return GestureDetector(
      onTap: () {
        _changeMat(_matrix, _dupmat, i, j);
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

  linearCong(a, x) {
    int q = 2, v = a.length - 2;
    var ind1 = (q + (x * v)) % a.length;
    return a[ind1.toInt()];
  }

  _changeMat(_matrix, _dupmat, Q, P) async {
    var lc = "o";
    if (_matrix[Q][P] == " ") {
      if (lc == "o") {
        setState(() {
          _matrix[Q][P] = "x";
          _dupmat[Q][P] = "x";
          lc = "x";
          turn = "O's Turn \n";
        });
        String winner = _checkWinner(_matrix);
        if (!promptResult(winner)) {
          var empty = [];
          for (var i = 0; i < 3; i++) {
            for (var j = 0; j < 3; j++) {
              if (_matrix[i][j] == ' ') {
                empty.add([i, j]);
              }
            }
          }
          if (empty.length != 1) {
            var m = empty.length;
            var x = m.isOdd ? (m + 1) / 2 : (m) / 2;
            var r = linearCong(empty, x);
            await Future.delayed(Duration(seconds: 1)).then((_) {
              setState(() {
                _matrix[r[0]][r[1]] = "o";
                _dupmat[r[0]][r[1]] = "o";
                lc = "o";
                turn = "X's Turn \n";
              });
            });
            winner = _checkWinner(_matrix);
            if (promptResult(winner)) empty.remove(r);
          } else {
            var r = empty[0];
            empty.remove(r);
            await Future.delayed(Duration(seconds: 1)).then((_) {
              setState(() {
                _matrix[r[0]][r[1]] = "o";
                _dupmat[r[0]][r[1]] = "o";
                lc = "o";
              });
              winner = _checkWinner(_matrix);
              promptResult(winner);
            });
          }
        }
      }
    }
  }

  promptResult(String winner) {
    if (winner == "x") {
      setState(() {
        this.scorePlayerX++;
        player.gameWon();
      });
      showDialogBox(
          context, "Congratulations!! \nPlayer X Won!!", player, _initMat);
      return true;
    } else if (winner == "o") {
      setState(() {
        this.scorePlayer0++;
        player.gameLoss();
      });
      showDialogBox(
          context, "Better Luck Next Time!! \nAI Won!!", player, _initMat);
      return true;
    } else if (winner == "tie") {
      setState(() {
        player.gameDraws();
      });
      showDialogBox(context, "Match Draw!! \nGreat Game", player, _initMat);
      return true;
    }
    return false;
  }

  _showDialog2(String p1) {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Colors.orange[200]),
            child: AlertDialog(
                title: Text(
                  "As a Rule of the Game, you only get 2 hint per game!\n\n$p1",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              hint = hint + 1;
                              player.hintRestore();
                            });
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    ])),
          );
        });
  }

  _hint() {
    if (hint > 0) {
      var score = 1000;
      var bestScore = 1000;
      var moveI = -10, moveJ = -10;
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          // Is the spot available?
          if (_matrix[i][j] == " ") {
            _dupmat[i][j] = "x";
            score = minimaxPlayer(_dupmat, 0, false);
            _dupmat[i][j] = ' ';
            if (score < bestScore) {
              bestScore = score;
              moveI = i;
              moveJ = j;
            }
          }
        }
      }
      setState(() {
        hint = hint - 1;
        player.hintUsed();
      });
      _changeMat(_matrix, _dupmat, moveI, moveJ);
    } else {
      _showDialog2("\n Need More?? Watch the Ad\n");
    }
  }

  int minimaxPlayer(_mat, depth, isMax) {
    var result = _checkWinner(_mat);
    if (result != "") {
      if (result == "x") {
        return 10;
      } else if (result == "o") {
        return -10;
      } else if (result == "tie") {
        return 0;
      }
    }
    if (isMax == true) {
      var score = -110;
      var bestScore = -10000;
      for (var o = 0; o < 3; o++) {
        for (var k = 0; k < 3; k++) {
          // Is the spot available?
          if (_mat[o][k] == " ") {
            _mat[o][k] = "x";
            score = _minimax(_mat, depth + 1, false);
            _mat[o][k] = " ";
            bestScore = (score > bestScore ? score : bestScore);
          }
        }
      }
      return bestScore;
    } else {
      var score = 110;
      var bestScore = 10000;
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          // Is the spot available?
          if (_mat[i][j] == ' ') {
            _mat[i][j] = "o";
            score = _minimax(_mat, depth + 1, true);
            _mat[i][j] = ' ';
            bestScore = (score < bestScore ? score : bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  int _minimax(_mat, depth, isMax) {
    var result = _checkWinner(_mat);
    if (result != "") {
      if (result == "x") {
        return (-10);
      } else if (result == "o") {
        return 10;
      } else if (result == "tie") {
        return 0;
      }
    }
    if (isMax == true) {
      var score = -110;
      var bestScore = -10000;
      for (var o = 0; o < 3; o++) {
        for (var k = 0; k < 3; k++) {
          // Is the spot available?
          if (_mat[o][k] == " ") {
            _mat[o][k] = "o";
            score = _minimax(_mat, depth + 1, false);
            _mat[o][k] = " ";
            bestScore = (score > bestScore ? score : bestScore);
          }
        }
      }
      return bestScore;
    } else {
      var score = 110;
      var bestScore = 10000;
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          // Is the spot available?
          if (_mat[i][j] == ' ') {
            _mat[i][j] = "x";
            score = _minimax(_mat, depth + 1, true);
            _mat[i][j] = ' ';
            bestScore = (score < bestScore ? score : bestScore);
          }
        }
      }
      return bestScore;
    }
  }

  bool _equals3(a, b, c) {
    return a == b && b == c && a != ' ';
  }

  String _checkWinner(board) {
    var winner = "";

    // horizontal
    for (var i = 0; i < 3; i++) {
      if (_equals3(board[i][0], board[i][1], board[i][2])) {
        winner = board[i][0];
      }
    }

    // Vertical
    for (var i = 0; i < 3; i++) {
      if (_equals3(board[0][i], board[1][i], board[2][i])) {
        winner = board[0][i];
      }
    }

    // Diagonal
    if (_equals3(board[0][0], board[1][1], board[2][2])) {
      winner = board[0][0];
    }
    if (_equals3(board[2][0], board[1][1], board[0][2])) {
      winner = board[2][0];
    }

    var openSpots = 0;
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (board[i][j] == ' ') {
          openSpots++;
        }
      }
    }

    if (winner == "" && openSpots == 0) {
      return "tie";
    } else {
      return winner;
    }
  }
}
