import 'package:flutter/material.dart';
import 'package:gamedise/ChoosePage.dart';
import 'package:gamedise/MainScorePage.dart';
import 'package:gamedise/splashscreen.dart';
import 'package:gamedise/sudoku/SudokuMain.dart';
import 'package:gamedise/sudoku/SudokuMainPage.dart';
import 'package:gamedise/sudoku2/SolveSudoku.dart';
import 'package:gamedise/tictactoe/TicTacToeMainPage.dart';
import 'package:gamedise/tictactoe/VsPlayer.dart';
import 'package:gamedise/tictactoe/ScorePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gamedise/tictactoe/VsAIHard.dart';
import 'package:gamedise/tictactoe/vsAISimple.dart';


Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Gamedise());
}

class Gamedise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GameDise - A Paradise of Games",
      initialRoute: SplashPage.routeName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        SplashPage.routeName: (BuildContext context) => SplashPage(),
        ChoosePage.routeName: (BuildContext context) => ChoosePage(),
        SudokuMainPage.routeName: (BuildContext context) => SudokuMainPage(),
        // SudokuSolverPage.routeName: (BuildContext context) => SudokuSolverPage(),
        SudokuMain.routeName: (BuildContext context) => SudokuMain(),
        TicTacToeMainPage.routeName: (BuildContext context) => TicTacToeMainPage(),
        VsPlayer.routeName: (BuildContext context) => VsPlayer(),
        VsAIHard.routeName: (BuildContext context) => VsAIHard(),
        VsAISimple.routeName: (BuildContext context) => VsAISimple(),
        ScorePage.routeName: (BuildContext context) => ScorePage(),
        MainScorePage.routeName: (BuildContext context) => MainScorePage(),
        SolveSudoku.routeName: (BuildContext context) => SolveSudoku(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}