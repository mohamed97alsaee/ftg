import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:free_to_play_challange/models/game_model.dart';
import 'package:http/http.dart' as http;

class GamesProvider with ChangeNotifier {
  List<GameModel> games = [];
  bool isLoading = false;
  bool isFailed = false;

  getGames() async {
    isLoading = true;
    notifyListeners();
    final response =
        await http.get(Uri.parse('https://www.freetogame.com/api/games'));

    if (response.statusCode == 200 && response.toString() != 'null') {
      final data = json.decode(response.body) as List;
      setGames(data.map((e) => GameModel.fromJson(e)).toList());
    } else {
      // print("ERROR HERE : " + response.body.toString());
      isFailed = true;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  setGames(List<GameModel> data) {
    games = data;
    notifyListeners();
  }

  // addNewGame(GameModel game) {
  //   games.add(game);
  //   notifyListeners();
  // }
}
