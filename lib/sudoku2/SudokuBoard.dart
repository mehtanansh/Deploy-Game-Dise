import 'package:flutter/material.dart';
import 'package:gamedise/sudoku2/sudoku_solver.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SudokuBoard extends StatelessWidget {
  final int mode;
  SudokuBoard(this.mode);
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        left: BorderSide(width: 3.0, color: Colors.black),
        top: BorderSide(width: 3.0, color: Colors.black),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _getTableRows(),
    );
  }

  List<TableRow> _getTableRows() {
    return List.generate(9, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(9, (int colNumber) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              width: (colNumber % 3 == 2) ? 3.0 : 1.0,
              color: Colors.black,
            ),
            bottom: BorderSide(
              width: (rowNumber % 3 == 2) ? 3.0 : 1.0,
              color: Colors.black,
            ),
          ),
        ),
        child: SudokuCell(rowNumber, colNumber, mode),
      );
    });
  }
}

class SudokuCell extends StatelessWidget {
  final int row, col, mode;
  SudokuCell(this.row, this.col, this.mode);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        // Set the board cell to activeNumber...
        Provider.of<SudokuChangeNotifier>(context, listen: false)
            .setBoardCell(this.row, this.col);
        Future.delayed(Duration(seconds: 10));
      },
      child: SizedBox(
        width: 30,
        height: 30,
        child: Selector<SudokuChangeNotifier, Tuple2<String, Color>>(
          builder: (context, data, child) {
            // Using selector to rebuild, only if the value changes
            // Using board cell value.
            return Container(
              color: data.item2,
              child: Center(
                child: Text(data.item1),
              ),
            );
          },
          selector: (context, sudokuChangeNotifier) => Tuple2(
              sudokuChangeNotifier.getBoardCell(
                  this.row, this.col, this.mode),
              sudokuChangeNotifier.getBoardCellColor(this.row, this.col)),
        ),
      ),
    );
  }
}

class KeyPad extends StatelessWidget {
  final int numRows = 2;
  final int numColumns = 5;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _getTableRows(),
    );
  }

  List<TableRow> _getTableRows() {
    return List.generate(this.numRows, (int rowNumber) {
      return TableRow(children: _getRow(rowNumber));
    });
  }

  List<Widget> _getRow(int rowNumber) {
    return List.generate(this.numColumns, (int colNumber) {
      return Padding(
        padding: const EdgeInsets.all(5),
        child: KeyPadCell(this.numColumns * rowNumber + colNumber),
      );
    });
  }
}

class KeyPadCell extends StatelessWidget {
  final int number;

  KeyPadCell(this.number);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 50,
      child: Selector<SudokuChangeNotifier, Color>(
        builder: (context, buttonColor, child) {
          return FlatButton(
            splashColor: Color(0xFF0E7B8B),
            highlightColor: Colors.transparent,
            color: buttonColor,
            onPressed: () {
              final String message = this.number == 0
                  ? 'Use to clear squares'
                  : 'Fill all squares with value $number';
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(message),
                duration: Duration(seconds: 2),
              ));

              // Setting activeNumber here...
              Provider.of<SudokuChangeNotifier>(context, listen: false)
                  .setActiveNumber(this.number);
            },
            child: child,
          );
        },
        selector: (context, sudokuChangeNotifier) =>
            sudokuChangeNotifier.getKeyPadColor(this.number),
        child: number == 0 ? Text('x') : Text('$number'),
      ),
    );
  }
}

class SudokuChangeNotifier with ChangeNotifier {
  List<List<int>> board = List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<int>> question =
      List.generate(9, (_) => List.generate(9, (_) => 0));
  List<List<int>> copyBoard =
      List.generate(9, (_) => List.generate(9, (_) => 0));
  int activeNumber = 0;
  int counter = 0;
  int celler = 0;
  bool soln = false;
  String level;
  int maxQ;
  int mode;

  List<List<Color>> sudokuCellColors =
      List.generate(9, (_) => List.generate(9, (_) => Colors.white));

  List<Color> keyPadColors = List.generate(10, (_) => Colors.white);

  bool isValid = true;

  final solver = SudokuSolver();
  int getNoOfQuestions(String level) {
    switch (level) {
      case 'beginner':
        return (81 - 18); // 18 empty cells
        break;
      case 'easy':
        return (81 - 27); // 27 empty cells
        break;
      case 'medium':
        return (81 - 36); // 36 empty cells
        break;
      case 'hard':
        return (81 - 54); // 54 empty cells
        break;
    }
  }

  String getBoardCell(int row, int col, int mode) {
    this.mode = mode;
    if (mode == 0) {
      setQuestion(row, col);
      this.celler++;
      if (this.celler >= 80 && this.soln == false) {
        this.copyBoard = this.board;
        this.soln = true;
      }
    }
    return this.board[row][col] == 0 ? '' : this.board[row][col].toString();
  }

  void setBoardCell(int row, int col) {
    this.sudokuCellColors[row][col] = this.activeNumber == 0 ? Colors.white : Colors.yellow;
    this.isValid = isValidOnChange(row, col, this.activeNumber);
    this.isValid = this.isBoardValid();
    if (!this.isValid) {
      this.sudokuCellColors[row][col] = Colors.white;
    }
    notifyListeners();
  }

  Color getBoardCellColor(int row, int col) {
    return this.sudokuCellColors[row][col];
  }

  Color getKeyPadColor(int number) {
    return this.keyPadColors[number];
  }

  void setKeyPadColor(int number, Color color) {
    this.keyPadColors[number] = color;
    notifyListeners();
  }

  int getActiveNumber(int number) {
    return this.activeNumber;
  }

  List<int> setList(String level)
  {
    switch(level){
      case 'beginner':
        return [0,1];
        break;
      case 'easy':
        return [0,1,2];
        break;
      case 'medium':
        return [0,1,2,3];
        break;
      case 'hard':
        return [0,1,2,3,4];
        break;
    }

  }

  void setQuestion(int row, int col) {
    this.maxQ = getNoOfQuestions(this.level);
    if (this.counter > this.maxQ) {
      this.board[row][col] = 0;
      this.question[row][col] = 0;
    } else {
      List<int> numberList = setList(this.level);
      numberList.shuffle();
      if (this.counter < this.maxQ) {
        switch (numberList[0]) {
          case 0:
            {
              do {
                int val = randomGenerator();
                this.board[row][col] = val;
                this.counter++;
                this.question[row][col] = this.board[row][col];
              } while (!this.isBoardValid());
            }
            break;
          default:
            {
              this.board[row][col] = 0;
              this.question[row][col] = 0;
            }
            break;
        }
      }
    }

    // if(this.question[row] == null)
    //   this.question[row][col] = this.board[row][col];
    // else
  }

  void setActiveNumber(int number) {
    // Reset the previous active number color
    this.keyPadColors[this.activeNumber] = Colors.white;

    // Set the active number and color
    this.activeNumber = number;
    this.keyPadColors[this.activeNumber] = Colors.yellow;
    notifyListeners();
  }

  static int randomGenerator() {
    List<int> numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    numberList.shuffle();
    return numberList[0];
  }

  void solveBoard(BuildContext context) async {
    await solver.solveSudoku(this.board, context);

    // Notifying listeners, as board changed
    // so need to rebuild all widgets using board.
    notifyListeners();
  }

  void reset() {
    this.resetBoard();
    this.resetSudokuCellColors();
    this.resetKeyPadColors();
    // Notifying listeners, as board changed
    // so need to rebuild all widgets using board.
    notifyListeners();
  }

  void resetBoard() {
    if (mode == 0) {
      for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
          int val = this.question[i][j];
          this.board[i][j] = val;
        }
      }
    } else {
      this.board = List.generate(9, (_) => List.generate(9, (_) => 0));
    }
    this.activeNumber = 0;
  }

  void resetSudokuCellColors() {
    this.sudokuCellColors =
        List.generate(9, (_) => List.generate(9, (_) => Colors.white));
  }

  void resetKeyPadColors() {
    this.keyPadColors = List.generate(10, (_) => Colors.white);
  }

  bool isValidOnChange(int row, int col, int number) {
    if (this.question[row][col] != number && number == 0) {
      return true;
    }
    if (number == 0) {
      this.board[row][col] = 0;
      return true;
    }

    // Checking row
    for (int currCol = 0; currCol != col && currCol < 9; ++currCol) {
      if (this.board[row][currCol] == number) {
        return false;
      }
    }

    // Checking col
    for (int currRow = 0; currRow != row && currRow < 9; ++currRow) {
      if (this.board[currRow][col] == number) {
        return false;
      }
    }

    // Checking region
    int xRegion = row ~/ 3;
    int yRegion = col ~/ 3;
    for (int x = xRegion * 3; x < xRegion * 3 + 3; x++) {
      for (int y = yRegion * 3; y < yRegion * 3 + 3; y++) {
        if (!(x == row && y == col) && this.board[x][y] == number) {
          return false;
        }
      }
    }
    this.board[row][col] = this.activeNumber;
    return true;
  }

  bool isBoardValid() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (!(isRowValid(row) && isColumnValid(col) && isRegionValid(row, col)))
          return false;
      }
    }
    return true;
  }

  bool isRowValid(int row) {
    return this.areDuplicatesPresent(this.board[row].toList(growable: false));
  }

  bool isColumnValid(int col) {
    return this.areDuplicatesPresent(
        this.board.map((rowElem) => rowElem[col]).toList(growable: false));
  }

  bool isRegionValid(int row, int col) {
    List<int> region = List<int>();
    int xRegion = row ~/ 3;
    int yRegion = col ~/ 3;
    for (int x = xRegion * 3; x < xRegion * 3 + 3; x++) {
      for (int y = yRegion * 3; y < yRegion * 3 + 3; y++) {
        region.add(this.board[x][y]);
      }
    }

    return this.areDuplicatesPresent(region);
  }

  bool areDuplicatesPresent(List<int> a) {
    a.sort();
    for (int i = 1; i < a.length; i++)
      if (a[i] != 0 && a[i - 1] == a[i]) return false;
    return true;
  }
}
