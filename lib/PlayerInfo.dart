import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerInfo {
  String name;
  String deviceId;
  int wins = 0;
  int loss = 0;
  int draws = 0;
  int totalGamePlayed = 0;
  int totalSudokuSolved = 0;
  int totalWins;
  int totalLoss;
  int totalDraws;
  int overallTotalGamePlayed;
  int hint;
  int mode = 0;
  String level;
  String player2;
  bool play = false;
  bool sudoku = false;

  PlayerInfo(deviceId, {name}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDeviceId(deviceId);
      name==null?_registerDevice():getUserData(deviceId);
    });
  }

  void setGame(int mode,{bool reset = false})
  {
    setWins(reset?this.wins:0);
    setLoss(reset?this.loss:0);
    setDraws(reset?this.draws:0);
    setTotalGamePlayed(reset?this.totalGamePlayed:0);
    hintReset();
    setMode(mode);
  }

  void changeName(deviceId, name) {
    setDeviceId(deviceId);
    setName(name);
    _giveNewName(name);
  }

  void setDeviceId(String data) {
    this.deviceId = data;
  }

  void gameWon() async {
    this.wins++;
    setTotalWins(1);
    incrementTotalGamePlayed();
  }

  void gameLoss() async {
    this.loss++;
    setTotalLoss(1);
    incrementTotalGamePlayed();
  }

  void gameDraws() async {
    this.draws++;
    setTotalDraws(1);
    incrementTotalGamePlayed();
  }

  Future<void> incrementTotalSudokuSolved() async {
    this.totalSudokuSolved++;
    DatabaseReference dbRef = FirebaseDatabase.instance.reference();
    await dbRef.child(this.deviceId).child("totalSudokuSolved").set(this.totalSudokuSolved);
  }

  Future<void> incrementTotalGamePlayed() async {
    print("1. totalGamePlayed: ${this.totalGamePlayed} =>> Total Overall Game Played ${this.overallTotalGamePlayed}");
    this.totalGamePlayed++;
    print("2. totalGamePlayed: ${this.totalGamePlayed} =>> Total Overall Game Played ${this.overallTotalGamePlayed}");
    this.setOverallTotalGamePlayed(1);
    print("3. totalGamePlayed: ${this.totalGamePlayed} =>> Total Overall Game Played ${this.overallTotalGamePlayed}");
  }

  void setMode(int data) {
    this.mode = data;
  }

  void setName(String name) async {
    this.name = name;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }

  void setWins(int wins) {
    this.wins = this.wins == null ? 0 : this.wins;
    this.wins = wins;
  }

  void setLoss(int loss) {
    this.loss = this.loss == null ? 0 : this.loss;
    this.loss = loss;
  }

  void setDraws(int draws) {
    this.draws = this.draws == null ? 0 : this.draws;
    this.draws = draws;
  }

  void setTotalGamePlayed(int totalGamePlayed) {
    this.totalGamePlayed = this.totalGamePlayed == null ? 0 : this.totalGamePlayed;
    this.totalGamePlayed = totalGamePlayed;
  }

  void setTotalWins(int wins) async {
    this.totalWins = this.totalWins == null ? 0 : this.totalWins;
    this.totalWins += wins;
    DatabaseReference dbRef = FirebaseDatabase.instance.reference();
    await dbRef.child(this.deviceId).child("totalWins").set(this.totalWins);
  }

  void setTotalLoss(int loss) async {
    this.totalLoss = this.totalLoss == null ? 0 : this.totalLoss;
    this.totalLoss += loss;
    DatabaseReference dbRef = FirebaseDatabase.instance.reference();
    await dbRef.child(this.deviceId).child("totalLoss").set(this.totalLoss);
  }

  void setTotalDraws(int draws) async {
    this.totalDraws = this.totalDraws == null ? 0 : this.totalDraws;
    this.totalDraws += draws;
    DatabaseReference dbRef = FirebaseDatabase.instance.reference();
    await dbRef.child(this.deviceId).child("totalDraws").set(this.totalDraws);
  }

  void setOverallTotalGamePlayed(int currentGamePlayed) async {
    this.overallTotalGamePlayed = this.overallTotalGamePlayed == null ? 0 : this.overallTotalGamePlayed;
    print("\t1. overallTotalGamePlayed: ${this.overallTotalGamePlayed}");
    this.overallTotalGamePlayed+=currentGamePlayed;
    print("\t2. overallTotalGamePlayed: ${this.overallTotalGamePlayed}");
    DatabaseReference dbRef = FirebaseDatabase.instance.reference();
    await dbRef.child(this.deviceId).child("overallTotalGamePlayed").set(this.overallTotalGamePlayed);
  }

  void setTotalSudokuSolved(int totalSudokuSolved) {
    this.totalSudokuSolved = totalSudokuSolved;
  }

  void setHint(int hint) {
    this.hint = hint;
  }

  void hintReset() async {
    this.hint = 2;
  }

  void hintRestore() async {
    this.hint++;
  }

  void hintUsed() async {
    this.hint--;
  }

  Future<void> _giveNewName(name) async {
    try {
      DatabaseReference dbRef = FirebaseDatabase.instance.reference();
      await dbRef.child(this.deviceId).child("playerName").set(name);
      setName(name);
    } catch (err) {
      print("Error: ${err.message}");
    }
  }

  Future<void> _registerDevice() async {
     if ((this.name == "") || (this.name == null) || (this.name.isEmpty))
     {
    try {
      Random random = new Random();
      int randomNumber = random.nextInt(100) + 1000;
      DatabaseReference dbRef = FirebaseDatabase.instance.reference();
      await dbRef.child(this.deviceId).set({
        "playerName": "Guest_$randomNumber",
        "totalWins": 0,
        "totalLoss": 0,
        "totalDraws": 0,
        "overallTotalGamePlayed": 0,
        "totalSudokuSolved": 0,
      });
      setName("Guest_$randomNumber");
      setTotalWins(0);
      setTotalLoss(0);
      setTotalDraws(0);
      setOverallTotalGamePlayed(0);
      setTotalSudokuSolved(0);
      setHint(2);
    } catch (err) {
      print("Error: ${err.message}");
    }
  }
  }

  Future<void> getUserData(String id) async {
    final uid = id;
    final dbRef = FirebaseDatabase.instance.reference();
    await dbRef.once().then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, val) {
        //=> vv.forEach((key, val){
        if (key == uid) {
          setName(val['playerName']);
          setTotalWins(val['totalWins']);
          setTotalLoss(val['totalLoss']);
          setTotalDraws(val['totalDraws']);
          setHint(2);
          setOverallTotalGamePlayed(val['overallTotalGamePlayed']);
          setTotalSudokuSolved(val['totalSudokuSolved']);
        }
        // })
      });
    });
    // Future.delayed(Duration(seconds: 100));
  }
}
