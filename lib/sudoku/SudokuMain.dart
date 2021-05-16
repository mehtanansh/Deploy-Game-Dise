import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/sudoku/Alerts.dart';
import 'package:gamedise/sudoku/Styles.dart';
import 'package:gamedise/sudoku/Sudoku.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class SudokuMain extends StatefulWidget {
  static const routeName = '/SudokuMain';
  @override
  State<StatefulWidget> createState() => SudokuMainState();
}

class SudokuMainState extends State<SudokuMain> {
  bool firstRun = true;
  bool gameOver = false;
  int timesCalled = 0;
  bool isButtonDisabled = false;
  bool isFABDisabled = false;
  List<List<List<int>>> gameList;
  List<List<int>> game;
  List<List<int>> gameCopy;
  List<List<int>> gameSolved;
  static String currentDifficultyLevel;
  static String currentTheme;
  static String platform;
  var borderColor = Colors.lightBlue;
  String player1Name;
  int hint;
  Timer _timer;
  var interval = const Duration(seconds: 1);
  int currentSeconds = 0;
  String timerText = "00:00:00";
  PlayerInfo player;

  @override
  void initState() {
    super.initState();
    getPrefs().whenComplete(() {
      if (currentDifficultyLevel == null) {
        currentDifficultyLevel = 'easy';
        setPrefs();
      }
    newGame(currentDifficultyLevel);
    setState(() {
          Styles.bg = Styles.light;
          Styles.bg_2 = Styles.light;
          Styles.fg = Styles.dark;
    });
    });
    startTimer();
  }

  void dispose()
  {
    super.dispose();
  _timer.cancel();
    
  }

  Future<void> getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentDifficultyLevel = prefs.getString('currentDifficultyLevel');
    });
  }

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentDifficultyLevel', currentDifficultyLevel);
  }

  void checkResult() {
    if (game.toString() == gameSolved.toString()) {
      gameOver = true;
      _timer = new Timer(Duration(milliseconds: 500), () {
        showDialog(
            context: context,
            builder: (context) {
              return Theme(
                  data: Theme.of(context)
                      .copyWith(dialogBackgroundColor: Colors.orange[400]),
                  child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      title: Center(
                          child: Text(
                        'You have taken $timerText',
                        style: TextStyle(
                            color: Color(0xFF320A3A),
                            fontWeight: FontWeight.bold),
                      )),
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              player.incrementTotalSudokuSolved();
                              Navigator.of(context).pop();
                              restartGame();
                            },
                            child: Text(
                              "Restart Game",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0E7B8B),
                              ),
                            ),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              player.incrementTotalSudokuSolved();
                              Navigator.of(context).pop();
                              newGame();
                            },
                            child: Text(
                              "New Game",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0E7B8B),
                              ),
                            ),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              player.incrementTotalSudokuSolved();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Quit Game",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF0E7B8B),
                              ),
                            ),
                          ),
                        ],
                      )));
            });
      });
    }
  }

  static List<List<List<int>>> getNewGame([String difficulty = 'easy']) {
    Sudoku object = new Sudoku(difficulty);
    return [object.newSudoku, object.newSudokuSolved];
  }

  void setGame(int mode, [String difficulty = 'easy']) {
    if (mode == 1) {
      game = new List.generate(9, (i) => [0, 0, 0, 0, 0, 0, 0, 0, 0]);
      gameCopy = Sudoku.copyGrid(game);
      gameSolved = Sudoku.copyGrid(game);
    } else {
      gameList = getNewGame(difficulty);
      game = gameList[0];
      gameCopy = Sudoku.copyGrid(game);
      gameSolved = gameList[1];
    }
  }

  void showSolution() {
    if (hint > 0) {
    setState(() {
      game = Sudoku.copyGrid(gameSolved);
      gameOver = true;
    });
      setState(() {
        hint = hint - 1;
        player.hintUsed();
      });
    }
    else{
      _showDialog2("\n Need More?? Watch the Ad\n");
    }
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
                  "As a Rule of the Game, you only get 2 hints per game!\n\n$p1",
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

  void newGame([String difficulty = 'easy']) {
    setState(() {
      setGame(2, difficulty);
      gameOver = false;
    });
  }

  void restartGame() {
    setState(() {
      game = Sudoku.copyGrid(gameCopy);
      gameOver = false;
    });
  }

  Color buttonColor(int k, int i) {
    Color color;
    if (([0, 1, 2].contains(k) && [3, 4, 5].contains(i)) ||
        ([3, 4, 5].contains(k) && [0, 1, 2, 6, 7, 8].contains(i)) ||
        ([6, 7, 8].contains(k) && [3, 4, 5].contains(i))) {
      if (Styles.bg == Styles.dark) {
        color = Styles.grey;
      } else {
        color = Colors.grey[300];
      }
    } else {
      color = Styles.bg;
    }

    return color;
  }

  BorderRadiusGeometry buttonEdgeRadius(int k, int i) {
    if (k == 0 && i == 0) {
      return BorderRadius.only(topLeft: Radius.circular(5));
    } else if (k == 0 && i == 8) {
      return BorderRadius.only(topRight: Radius.circular(5));
    } else if (k == 8 && i == 0) {
      return BorderRadius.only(bottomLeft: Radius.circular(5));
    } else if (k == 8 && i == 8) {
      return BorderRadius.only(bottomRight: Radius.circular(5));
    }
    return BorderRadius.circular(0);
  }

  List<SizedBox> createButtons() {
    if (firstRun) {
      setGame(1);
      firstRun = false;
    }
    MaterialColor emptyColor;
    if (gameOver) {
      emptyColor = Styles.primaryColor;
    } else {
      emptyColor = Styles.secondaryColor;
    }
    List<SizedBox> buttonList = new List<SizedBox>.filled(9, null);
    for (var i = 0; i <= 8; i++) {
      var k = timesCalled;
      buttonList[i] = SizedBox(
        width: 38,
        height: 38,
        child: TextButton(
          onPressed: isButtonDisabled || gameCopy[k][i] != 0
              ? null
              : () {
                  setState(() {
                    isFABDisabled = true;
                  });
                  showAnimatedDialog<void>(
                      animationType: DialogTransitionType.fade,
                      barrierDismissible: true,
                      duration: Duration(milliseconds: 300),
                      context: context,
                      builder: (_) => AlertNumbersState()).whenComplete(() {
                    callback([k, i], AlertNumbersState.number);
                    AlertNumbersState.number = null;
                    setState(() {
                      isFABDisabled = false;
                    });
                  });
                },
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(buttonColor(k, i)),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return gameCopy[k][i] == 0 ? emptyColor : Styles.fg;
              }
              return game[k][i] == 0
                  ? buttonColor(k, i)
                  : Styles.secondaryColor;
            }),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: buttonEdgeRadius(k, i),
            )),
            side: MaterialStateProperty.all<BorderSide>(BorderSide(
              color: Styles.fg,
              width: 1,
              style: BorderStyle.solid,
            )),
          ),
          child: Text(
            game[k][i] != 0 ? game[k][i].toString() : ' ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }
    timesCalled++;
    if (timesCalled == 9) {
      timesCalled = 0;
    }
    return buttonList;
  }

  Row oneRow() {
    return Row(
      children: createButtons(),
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  List<Row> createRows() {
    List<Row> rowList = new List<Row>.filled(9, null);
    for (var i = 0; i <= 8; i++) {
      rowList[i] = oneRow();
    }
    return rowList;
  }

  void callback(List<int> index, int number) {
    setState(() {
      if (number == null) {
        return;
      }
      game[index[0]][index[1]] = number;
      checkResult();
    });
  }

  void startTimer() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        timerText =
            '${((currentSeconds) ~/ 3600).toString().padLeft(2, '0')}:${((currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((currentSeconds) % 60).toString().padLeft(2, '0')}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.player = ModalRoute.of(context).settings.arguments;
    player1Name = player.name;
    hint = player.hint;
    return WillPopScope(
    onWillPop: ()=>onBackPressed(context),
          child: Scaffold(
        backgroundColor: Styles.bg,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Sudoku'),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: background(),
            child: Column(
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Time Consumed: ",
                          style:
                              TextStyle(color: Color(0xFF51B7C7), fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          " $timerText",
                          style: TextStyle(
                              color: Color(0xFF51B7C7),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: createRows(),
                    ),
                  ),
                Column(
                  children: [
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
                        children: [homeButton(context, player),
                          resetBoardButton(context,player, restartGame),
                          hintButton(context, hint,player, showSolution),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
