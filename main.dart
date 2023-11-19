import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PuzzleGame(),
    );
  }
}

class PuzzleGame extends StatefulWidget {
  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  late List<int> numbers;
  int gridSize = 4;
  int moveCount = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    moveCount = 0;
    numbers = List.generate(gridSize * gridSize - 1, (index) => index + 1);
    numbers.add(0);
    numbers.shuffle();
  }

  bool isSolved() {
    for (int i = 0; i < numbers.length - 1; i++) {
      if (numbers[i] != i + 1) {
        return false;
      }
    }
    return true;
  }

  void handleTileTap(int tappedIndex) {
    setState(() {
      int emptyIndex = numbers.indexOf(0);
      if ((emptyIndex - tappedIndex).abs() == 1 ||
          (emptyIndex - tappedIndex).abs() == gridSize) {
        int temp = numbers[tappedIndex];
        numbers[tappedIndex] = numbers[emptyIndex];
        numbers[emptyIndex] = temp;
        moveCount++;
        if (isSolved()) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Congratulations!'),
                content: Text('You solved the puzzle in $moveCount moves!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      startGame();
                    },
                    child: Text('Play Again'),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('15-Puzzle Game'),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: GestureDetector(
                onTap: () => startGame(),
                child: Text(
                  'New Game',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600]),
                ),
              )),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => handleTileTap(index),
                  child: Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: numbers[index] != 0
                          ? Border.all(
                              color: Colors.amber.shade700,
                              width: 4.0,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Text(
                        numbers[index] != 0 ? '${numbers[index]}' : '',
                        style: TextStyle(
                          fontSize: 50.0,
                          color: Colors.amber[700],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: numbers.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Moves: $moveCount',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600]),
            ),
          ),
        ],
      ),
    );
  }
}
