import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/sudoku/SudokuMain.dart';
import 'package:gamedise/sudoku2/SolveSudoku.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:gamedise/sudoku/SudokuSolverPage.dart';

class SudokuMainPage extends StatefulWidget {
  static const routeName = '/SudokuMainPage';

  @override
  _SudokuMainPageState createState() => _SudokuMainPageState();
}

class _SudokuMainPageState extends State<SudokuMainPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  String player1Name = "";
  String label;
  static PlayerInfo player;
  var _namer;

  setCurrentDifficultyLevel() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentDifficultyLevel', this.currentDifficultyLevel);
  }
  @override
  Widget build(BuildContext context) {
    player = ModalRoute.of(context).settings.arguments;
    label = player.name.isEmpty ? "Your Name": ""; 
    player1Name = player.name;
    _namer = TextEditingController(text: player1Name.isEmpty ? "" : player1Name);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Sudoku"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: background(),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: label,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      ),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 40),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: player1Name.isEmpty ? 1 : 5,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 40),
                    validator: validateName,
                controller: _namer,
                    keyboardType: TextInputType.name,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    _sendToServer();
                  },
                  radius: 40,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 2.0,
                            blurRadius: 15.0,
                            offset: Offset.fromDirection(-18, 10),
                          ),
                        ]),
                    child: Text(
                      "Save Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    _buttonAction(true, player);
                  },
                  radius: 40,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Color(0xFF14D0FF),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 2.0,
                            blurRadius: 15.0,
                            offset: Offset.fromDirection(-18, 10),
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.gamepad_rounded,
                          size: 35,
                          color: Colors.white,
                        ),
                        Text(
                          "New Sudoku",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 1,
                      color: Colors.white,
                    ),
                    Text(
                      "or",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 1,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    _buttonAction(false, player);
                  },
                  radius: 40,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                        color: Color(0xFF14D0FF),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 2.0,
                            blurRadius: 15.0,
                            offset: Offset.fromDirection(-18, 10),
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                        Text(
                          "Solve Sudoku",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String currentDifficultyLevel;

  String validateName(String value) {
    setState(() {
      label = player1Name.isEmpty ? 'Your Name' : "";
    });
    String pattern = r'(^[a-z A-Z,.\-]+$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Name cannot be Empty";
    } else if (!regExp.hasMatch(value)) {
      return "Name must have Alphabetic characters";
    }
    return null;
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      player1Name = _namer.text;
      player.changeName(player.deviceId, player1Name);
      _key.currentState.save();
    }
  }

  _buttonAction(bool newGame, PlayerInfo player) async {
    if (player1Name.length > 0) {
      setState(() {
        player.play = false;
        player.sudoku = true;
      });
      if (newGame) {
        player.mode = 0;
        difficultyAlert(player);
      } else {
        player.mode = 1;
        await Navigator.pushNamed(context, SolveSudoku.routeName, arguments: player);
      }
    }
  }
  static final List<String> difficulties = [
    'beginner',
    'easy',
    'medium',
    'hard'
  ];

  difficultyAlert(PlayerInfo player) {
    return showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Colors.orange[400]),
            child: AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(
          child: Text(
        'Select Difficulty Level',style: TextStyle(color: Color(0xFF320A3A),fontWeight: FontWeight.bold),
      )),
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        for (String level in difficulties)
          SimpleDialogOption(
            onPressed: () {
                setState(() async {
                  this.currentDifficultyLevel = level;
                  player.level = this.currentDifficultyLevel;
                  setCurrentDifficultyLevel();
                  await Navigator.popAndPushNamed(context, SudokuMain.routeName, arguments: player);
                });
            },
            child: Text(
              level.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20, color: Color(0xFF0E7B8B),
              ),
            ),
          ),
      ],
    )));
  });
  }
}


