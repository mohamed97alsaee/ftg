import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:free_to_play_challange/models/game_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;
  List<GameModel> games = [];
  fetchGames() async {
    final response =
        await http.get(Uri.parse('https://www.freetogame.com/api/games'));

    if (response.statusCode == 200) {
      for (var x in json.decode(response.body)) {
        games.add(GameModel.fromJson(x));
      }
      setState(() {});
    } else {
      print("FAILED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text(games.length.toString()),
        onPressed: () {
          fetchGames();
        },
      ),
      body: GridView.builder(
          itemCount: games.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return GridTile(
              child: Image.network(
                games[index].thumbnail,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.windows), label: 'PC'),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.weebly), label: 'Web'),
        ],
        onTap: ((value) {
          setState(() {
            navIndex = value;
          });
        }),
      ),
    );
  }
}
