import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamedise/MyTheme.dart';
import 'package:gamedise/PlayerInfo.dart';
import 'package:gamedise/tictactoe/VsAIHard.dart';
import 'package:gamedise/tictactoe/VsAISimple.dart';
import 'package:gamedise/tictactoe/VsPlayer.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';

class TicTacToeMainPage extends StatefulWidget {
  static const routeName = '/TicTacToeMainPage';
  @override
  _TicTacToeMainPageState createState() => _TicTacToeMainPageState();
}

class _TicTacToeMainPageState extends State<TicTacToeMainPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  String player1Name = "", player2Name = "Player2";
  String label;
  static PlayerInfo player;
  var _namer, _namer2;

  @override
  Widget build(BuildContext context) {
    player = ModalRoute.of(context).settings.arguments;
    label = player.name.isEmpty ? "Your Name" : "";
    player1Name = player.name;
    _namer =
        TextEditingController(text: player1Name.isEmpty ? "" : player1Name);
    _namer2 =
        TextEditingController(text: player2Name.isEmpty ? "" : player2Name);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
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
                Text(
                  "vs",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
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
                    width: MediaQuery.of(context).size.width / 2,
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
                        FaIcon(
                          FontAwesomeIcons.robot,
                          size: 35,
                          color: Colors.white,
                        ),
                        Text(
                          "Agent",
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
                    width: MediaQuery.of(context).size.width / 2,
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
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                        Text(
                          "Player",
                          style: TextStyle(
                            fontSize: 20,
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

  String validatePlayer2Name(String value) {
    setState(() {
      label = player2Name.isEmpty ? 'Your Name' : "";
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

  _buttonAction(bool vsAgent, PlayerInfo player) async {
    if (player1Name.length > 0) {
      if (vsAgent) {
        _showDialog2();
      } else {
        getPlayer2Name();
      }
    }
  }

  _showDialog2() {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context)
                .copyWith(dialogBackgroundColor: Colors.orange[200]),
            child: AlertDialog(
                title: Text(
                  "Level of Difficulty:",
                  textAlign: TextAlign.center,
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
                          onPressed: () async {
                            await player.setGame(0);
                  player.sudoku = false;
                  player.play = false;
                            await Navigator.popAndPushNamed(
                                context, VsAISimple.routeName,
                                arguments: player);
                          },
                          child: Text(
                            'Easy',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      TextButton(
                          onPressed: () async {
                            await player.setGame(1);
                  player.sudoku = false;
                  player.play = false;
                            await Navigator.popAndPushNamed(
                                context, VsAIHard.routeName,
                                arguments: player);
                          },
                          child: Text(
                            'Hard',
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

  getPlayer2Name() {
  GlobalKey<FormState> _key2 = new GlobalKey();
    Timer(Duration(milliseconds: 500), () {
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
                  'Enter Player2 Name',
                  style: TextStyle(
                      color: Color(0xFF320A3A), fontWeight: FontWeight.bold),
                )),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                content: Form(
                  key: _key2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              labelText: label,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                              labelStyle:
                                  TextStyle(color: Colors.white, fontSize: 40),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: player1Name.isEmpty ? 1 : 5,
                                ),
                              ),
                              border: OutlineInputBorder(),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 40),
                            validator: validatePlayer2Name,
                            controller: _namer2,
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            this.player2Name = _namer2.text;
                            player.player2 = _namer2.text;
                  player.sudoku = false;
                            await player.setGame(2);
                            await Navigator.popAndPushNamed(
                                context, VsPlayer.routeName,
                                arguments: player);
                          },
                          radius: 40,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40)),
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
                          height: 15,
                        ),
                      ]),
                ),
              ),
            );
          });
    });
  }
}
