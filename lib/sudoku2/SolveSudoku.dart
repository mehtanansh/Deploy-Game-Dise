import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/sudoku2/SudokuBoard.dart';
import 'package:provider/provider.dart';

class SolveSudoku extends StatefulWidget {
  static const routeName = '/SolveSudoku';
  @override
  State<StatefulWidget> createState() => SolveSudokuState();
}

class SolveSudokuState extends State<SolveSudoku> {
  var borderColor = Colors.lightBlue;
  String player1Name;
  int mode;
  int hint;
  var interval = const Duration(seconds: 1);
  int currentSeconds = 0;
  String timerText = "00:00:00";
  PlayerInfo player;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    PlayerInfo player = ModalRoute.of(context).settings.arguments;
    player1Name = player.name;
    hint = player.hint;
    mode = player.mode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sudoku'),
      ),
      body: ChangeNotifierProvider<SudokuChangeNotifier>(
        create: (context) => SudokuChangeNotifier(),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: background(),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height / 2 * 1.1,
                  child: SudokuBoard(this.mode),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: KeyPad(),
                ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      homeButton(context, player),
                      Consumer<SudokuChangeNotifier>(
                          builder: (context, sudokuChangeNotifer, child) {
                        return resetBoardButton(context, player, restartGame,
                            sudokuChangeNotifer: sudokuChangeNotifer);
                      }),
                      // : SizedBox(width: 0),
                      Consumer<SudokuChangeNotifier>(
                        builder: (context, sudokuChangeNotifer, child) {
                          print("tapped Hint");
                          return hintButton(context, 2, player, _hint,
                              sudokuChangeNotifer: sudokuChangeNotifer);
                        },
                        child: Text('Solve!'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _hint(context, sudokuChangeNotifer) {
    if (sudokuChangeNotifer.isValid) {
      setState(() {
        sudokuChangeNotifer.solveBoard(context);
      });
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              Theme(
                data: Theme.of(context)
                    .copyWith(dialogBackgroundColor: Colors.orange[400]),
                child: new AlertDialog(
                  title: new Text(
                    'Invalid Entries',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  content: new Text(
                    'You have enterd invalid entries!!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ) ??
              false);
    }
  }

  restartGame(sudokuChangeNotifer) {
    // print("Clicked me!!!");
    sudokuChangeNotifer.reset();
  }
}
