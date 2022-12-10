import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:free_to_play_challange/models/game_model.dart';
import 'package:free_to_play_challange/screens/single_game_screen.dart';
import 'package:provider/provider.dart';

import '../providers/games_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;

  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false).getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gamesProviderFunctions = Provider.of<GamesProvider>(context);
    return Scaffold(
      body:
          Consumer<GamesProvider>(builder: (context, gamesProviderListener, _) {
        return GridView.builder(
            itemCount: gamesProviderListener.games.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => SingleGameScreen(
                              gameId: gamesProviderListener.games[index].id)));
                },
                child: GridTile(
                  header: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      gamesProviderListener.games[index].platform
                              .toLowerCase()
                              .contains('windows')
                          ? FontAwesomeIcons.windows
                          : FontAwesomeIcons.weebly,
                      color: Colors.white,
                    ),
                  ),
                  footer: Container(
                    color: Colors.amber.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        gamesProviderListener.games[index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  child: Image.network(
                    gamesProviderListener.games[index].thumbnail,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              );
            });
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
            gamesProviderFunctions.getGames();
          });

          // fetchGames();
        }),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {}, child: Text(games.length.toString())),
    );
  }
}
