import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<String>> gameGrid = [];
  String currentPlayer = '';

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    gameGrid = List.generate(3, (_) => List.filled(3, ''));
    currentPlayer = 'X';
    setState(() {});
  }

  void onCellTapped(int row, int col) {
    if (gameGrid[row][col].isEmpty) {
      setState(() {
        gameGrid[row][col] = currentPlayer;
        currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
      });
      String winner = checkForWinner();
      if (winner.isNotEmpty) {
        showWinnerDialog(winner);
      }
    }
  }

  String checkForWinner() {
    for (int i = 0; i < 3; i++) {
      if (gameGrid[i][0] == gameGrid[i][1] &&
          gameGrid[i][1] == gameGrid[i][2] &&
          gameGrid[i][0].isNotEmpty) {
        return gameGrid[i][0];
      }
      if (gameGrid[0][i] == gameGrid[1][i] &&
          gameGrid[1][i] == gameGrid[2][i] &&
          gameGrid[0][i].isNotEmpty) {
        return gameGrid[0][i];
      }
    }
    if (gameGrid[0][0] == gameGrid[1][1] &&
        gameGrid[1][1] == gameGrid[2][2] &&
        gameGrid[0][0].isNotEmpty) {
      return gameGrid[0][0];
    }
    if (gameGrid[0][2] == gameGrid[1][1] &&
        gameGrid[1][1] == gameGrid[2][0] &&
        gameGrid[0][2].isNotEmpty) {
      return gameGrid[0][2];
    }
    bool isDraw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (gameGrid[i][j].isEmpty) {
          isDraw = false;
          break;
        }
      }
    }
    if (isDraw) {
      return 'Empate';
    }
    return '';
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resultado:'),
        content:
        Text(winner == 'Empate' ? 'Empate!!' : 'Jogador $winner venceu!'),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: const Text('Jogue novamente!'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Flutter Jogo da Velha"),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const Text('Jogador atual:',style: TextStyle(fontSize: 18),),
                Text(currentPlayer,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
              ],
            ),
            const SizedBox(height: 50,),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final row = index ~/ 3;
                  final col = index % 3;
                  return GestureDetector(
                    onTap: () => onCellTapped(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text(
                          gameGrid[row][col],
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: resetGame,style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade300, // Background color
            ), child: const Text("Novo Jogo"),)
          ],
        ),
      ),
    );
  }
}