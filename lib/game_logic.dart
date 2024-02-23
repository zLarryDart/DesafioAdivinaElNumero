import 'dart:math';

// Enumeración para definir los niveles de dificultad del juego.
enum Difficulty { facil, medio, avanzado, extremo }

class GameLogic {
  // Atributos privados de la clase.
  int _numberToGuess;
  int _maxNumber;
  int _remainingGuesses;
  final List<int> _guesses = []; // Historial de intentos.
  final Random _random = Random(); // Generador de números aleatorios.
  List<bool> _gameResults = []; // true para victoria, false para derrota

  // Constructor que inicia el juego con una dificultad por defecto.
  GameLogic({Difficulty difficulty = Difficulty.facil})
      : _maxNumber = 0,
        _numberToGuess = 0,
        _remainingGuesses = 0 {
    setDifficulty(difficulty);
  }

  get wins => null;

  // Método para establecer la dificultad del juego y reiniciar el juego.
  void setDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.facil:
        _maxNumber = 10;
        _remainingGuesses = 5;
        break;
      case Difficulty.medio:
        _maxNumber = 20;
        _remainingGuesses = 8;
        break;
      case Difficulty.avanzado:
        _maxNumber = 100;
        _remainingGuesses = 15;
        break;
      case Difficulty.extremo:
        _maxNumber = 1000;
        _remainingGuesses = 25;
        break;
    }
    newGame(); // Reinicia el juego con la nueva configuración.
  }

  // Genera un nuevo número aleatorio como el número a adivinar.
  void newGame() {
    _numberToGuess = _random.nextInt(_maxNumber) + 1;
    _guesses.clear();
  }

  void resetGameResults() {
    _gameResults.clear();
  }

  // Comprueba si el intento es el número correcto.
  bool guessNumber(int guess) {
    if (_remainingGuesses > 0) {
      _remainingGuesses--;
      _guesses.add(guess);
      return guess == _numberToGuess;
    }
    return false;
  }

  // Comprueba si el número adivinado es mayor que el número a adivinar.
  bool isHigherNumber(int guess) {
    return guess < _numberToGuess;
  }

  // Comprueba si el número adivinado es menor que el número a adivinar.
  bool isLowerNumber(int guess) {
    return guess > _numberToGuess;
  }

  // Verifica si quedan intentos disponibles.
  bool hasAttemptsLeft() {
    return _remainingGuesses > 0;
  }

  // Getters para acceder a propiedades específicas desde fuera de la clase.
  int get numberToGuess => _numberToGuess;
  List<int> get guesses => _guesses;
  int get remainingGuesses => _remainingGuesses;
  int get maxNumber => _maxNumber;
  List<bool> get gameResults => _gameResults;
}
