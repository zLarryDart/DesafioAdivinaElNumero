import 'package:flutter/material.dart';
import 'game_logic.dart'; // Asegúrate de que este import corresponda a la ubicación de tu archivo game_logic.dart.

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adivina el Número',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameLogic _gameLogic = GameLogic();
  final TextEditingController _controller = TextEditingController();
  int _currentDifficultyIndex = 0;
  List<String> _guesses = [];
  String _hint = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.casino, color: Colors.white),
            SizedBox(width: 8.0),
            Text('Adivina el Número', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.purple[900],
        actions: <Widget>[
          Center(
            child: Text(
              'Intentos: ${_gameLogic.remainingGuesses}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 16.0),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Adivina el número entre 1 y ${_gameLogic.maxNumber}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Introduce tu número',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  _checkGuess(int.tryParse(_controller.text) ?? 0);
                  _controller.clear();
                },
                child: Text('Validar'),
              ),
              SizedBox(height: 24.0),
              if (_guesses.isNotEmpty) ...[
                Text('Historial de intentos que erraste:'),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _guesses.reversed
                        .map((guess) => Container(
                              margin: const EdgeInsets.all(17.0),
                              padding: const EdgeInsets.all(17.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 238, 2, 2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                guess,
                                style: TextStyle(
                                  color: guess == _guesses.last
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize:
                                      guess == _guesses.last ? 20.0 : 16.0,
                                  fontWeight: guess == _guesses.last
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Text(
                  _hint,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
              SizedBox(height: 24.0),
              Text(
                  "Dificultad: ${Difficulty.values[_currentDifficultyIndex].toString().split('.').last}"),
              Slider(
                min: 0,
                max: Difficulty.values.length - 1.toDouble(),
                divisions: Difficulty.values.length - 1,
                value: _currentDifficultyIndex.toDouble(),
                label: Difficulty.values[_currentDifficultyIndex]
                    .toString()
                    .split('.')
                    .last,
                onChanged: (double value) {
                  setState(() {
                    _currentDifficultyIndex = value.toInt();
                    _gameLogic.setDifficulty(
                        Difficulty.values[_currentDifficultyIndex]);
                    _gameLogic.newGame();
                    _controller.clear();
                    _guesses.clear();
                    _hint = '';
                  });
                },
              ),
              SizedBox(height: 24.0),
              Text("Historial de Juegos:"),
              SizedBox(height: 24.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _gameLogic.gameResults
                      .map((result) => Icon(
                            result ? Icons.check_circle_outline : Icons.cancel,
                            color: result ? Colors.green : Colors.red,
                            size: 40, // Increase the size of the icons
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _gameLogic
                        .resetGameResults(); // Llama al método para reiniciar el historial
                  });
                },
                child: Text('Reiniciar Historial de Juegos'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkGuess(int guess) {
    setState(() {
      final correct = _gameLogic.guessNumber(guess);
      if (!correct) {
        _guesses.add(guess.toString());
        if (_gameLogic.isHigherNumber(guess)) {
          _hint = 'El número debe ser mayor';
        } else {
          _hint = 'El número debe ser menor';
        }
        if (!_gameLogic.hasAttemptsLeft()) {
          _showLoseDialog();
        }
      } else {
        _showWinDialog();
      }
    });
  }

  void _showLoseDialog() {
    _gameLogic.gameResults.add(false); // Añade true para indicar una victoria
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Has perdido"),
          content: Text(
              "El número era: ${_gameLogic.numberToGuess}. Intenta de nuevo."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog() {
    _gameLogic.gameResults.add(true); // Añade true para indicar una victoria
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡Felicidades!"),
          content: Text("Has adivinado el número correctamente."),
          actions: <Widget>[
            TextButton(
              child: Text("Jugar de nuevo"),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _gameLogic.setDifficulty(Difficulty.values[
          _currentDifficultyIndex]); // Asegura que se reinicie con la dificultad actual
      _gameLogic.newGame();
      _guesses.clear();
      _hint = '';
    });
  }
}
