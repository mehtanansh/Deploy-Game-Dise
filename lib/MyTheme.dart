import 'package:flutter/material.dart';
import 'package:gamedise/ChoosePage.dart';
import 'package:gamedise/PlayerInfo.dart';

var borderColor = Colors.lightBlue;
background() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
        Color(0xFF320A3A),
        Color(0xFF0E7B8B),
      ]));
}

playerScore(name, score) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        "$name",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 27, color: Colors.amberAccent[400]),
      ),
      Text(
        "$score",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 47, color: Colors.amberAccent[400]),
      ),
    ],
  );
}

ticTacToeBoard(Function _buildElementBox, PlayerInfo player) {
  return Expanded(
    flex: 2,
    child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildElementBox(0, 0, player),
            _buildElementBox(0, 1, player),
            _buildElementBox(0, 2, player),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildElementBox(1, 0, player),
            _buildElementBox(1, 1, player),
            _buildElementBox(1, 2, player),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildElementBox(2, 0, player),
            _buildElementBox(2, 1, player),
            _buildElementBox(2, 2, player),
          ],
        ),
      ],
    ),
  );
}

borderCell(int row, int col) {
  BorderSide left, top, bottom, right, sideBorder, defaultSideBorder;
  defaultSideBorder = BorderSide(
    color: Colors.transparent,
    width: 0,
    // width: borderWidth/10,
  );
  sideBorder = BorderSide(
    color: borderColor,
    width: 2,
  );
  if (row == 0 && col == 0) {
    left = defaultSideBorder;
    top = defaultSideBorder;
    right = sideBorder;
    bottom = sideBorder;
  } else if (row == 0 && col == 1) {
    left = sideBorder;
    top = defaultSideBorder;
    right = sideBorder;
    bottom = sideBorder;
  } else if (row == 0 && col == 2) {
    left = sideBorder;
    top = defaultSideBorder;
    right = defaultSideBorder;
    bottom = sideBorder;
  } else if (row == 1 && col == 0) {
    left = defaultSideBorder;
    top = sideBorder;
    right = sideBorder;
    bottom = sideBorder;
  } else if (row == 1 && col == 1) {
    left = sideBorder;
    top = sideBorder;
    right = sideBorder;
    bottom = sideBorder;
  } else if (row == 1 && col == 2) {
    left = sideBorder;
    top = sideBorder;
    right = defaultSideBorder;
    bottom = sideBorder;
  } else if (row == 2 && col == 0) {
    left = defaultSideBorder;
    top = sideBorder;
    right = sideBorder;
    bottom = defaultSideBorder;
  } else if (row == 2 && col == 1) {
    left = sideBorder;
    top = sideBorder;
    right = sideBorder;
    bottom = defaultSideBorder;
  } else if (row == 2 && col == 2) {
    left = sideBorder;
    top = sideBorder;
    right = defaultSideBorder;
    bottom = defaultSideBorder;
  }
  return Border(
    top: top,
    left: left,
    right: right,
    bottom: bottom,
  );
}

showDialogBox(
    BuildContext context, String p1, PlayerInfo player, Function initMat) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(p1),
          actions: [
            InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                await initMat();
              },
              radius: 40,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Text(
                  "Reset Game",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                player.play = false;
                Navigator.of(context).pop();
                await initMat(status: true);
              },
              radius: 40,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                ),
                child: Text(
                  "Quit Game",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

homeButton(BuildContext context, PlayerInfo player) {
  return InkWell(
    child: Container(
      child: Icon(
        Icons.home,
        size: 40,
        color: borderColor,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: (player.play)
          ? (MediaQuery.of(context).size.width)
          : player.sudoku
              ? (MediaQuery.of(context).size.width) / 3
              : (MediaQuery.of(context).size.width) / 2,
      height: (MediaQuery.of(context).size.width / 3),
    ),
    onTap: () {
      Navigator.popAndPushNamed(context, ChoosePage.routeName,
          arguments: player);
    },
    splashColor: Colors.blue,
    radius: MediaQuery.of(context).size.width,
    borderRadius: BorderRadius.circular(30),
  );
}

hintButton(BuildContext context, hint, PlayerInfo player, Function _hint,
    {sudokuChangeNotifer}) {
  return InkWell(
    child: Container(
      child: Icon(
        hint == 0 ? Icons.lightbulb_outline : Icons.lightbulb,
        size: 40,
        color: hint == 0 ? borderColor : Colors.yellow,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: player.sudoku
          ? (MediaQuery.of(context).size.width / 4)
          : (MediaQuery.of(context).size.width / 2),
      height: (MediaQuery.of(context).size.width / 3),
    ),
    onTap: () {
      sudokuChangeNotifer == null
          ? _hint()
          : _hint(context, sudokuChangeNotifer);
    },
    splashColor: Colors.blue,
    radius: MediaQuery.of(context).size.width,
    borderRadius: BorderRadius.circular(30),
  );
}

resetBoardButton(BuildContext context, PlayerInfo player, Function reset,
    {sudokuChangeNotifer}) {
  return InkWell(
    child: Container(
      child: Icon(
        Icons.refresh_rounded,
        size: 40,
        color: Colors.lightGreenAccent[400],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: (MediaQuery.of(context).size.width / 3),
      height: (MediaQuery.of(context).size.width / 3),
    ),
    onTap: () {
      sudokuChangeNotifer == null
          ? player.sudoku
              ? reset()
              : reset(context)
          : reset(sudokuChangeNotifer);
    },
    splashColor: Colors.blue,
    radius: MediaQuery.of(context).size.width,
    borderRadius: BorderRadius.circular(30),
  );
}

Future<bool> onBackPressed(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) =>
          Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Colors.orange[400]),
            child: new AlertDialog(
              title: new Text(
                'Are you sure?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              content: new Text(
                'Do you want to exit the game?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text(
                    "No",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text(
                    "Yes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ) ??
          false);
}
