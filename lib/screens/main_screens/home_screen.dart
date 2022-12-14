import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:free_to_play_challange/main.dart';
import 'package:free_to_play_challange/providers/auth_provider.dart';
import 'package:free_to_play_challange/providers/them_provider.dart';
import 'package:free_to_play_challange/screens/main_screens/single_game_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/games_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navIndex = 0;

  @override
  void initState() {
    Provider.of<GamesProvider>(context, listen: false)
        .getGames('https://www.freetogame.com/api/games');
    Provider.of<ThemeProvider>(context, listen: false).getMode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gamesProviderFunctions = Provider.of<GamesProvider>(context);
    final themeProviderFunctions = Provider.of<ThemeProvider>(context);
    final authProviderFunctions = Provider.of<AuthProvider>(context);

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person),
              ),
              const ListTile(
                title: Text('darkMode'),
                leading: Icon(Icons.dark_mode),
              ),
              ListTile(
                onTap: () async {
                  bool x = await authProviderFunctions.logout();
                  if (x) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ScreenRouter()),
                        (route) => false);
                  }
                },
                title: Text('Logout'),
                leading: Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(actions: [
        Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return IconButton(
              onPressed: () {
                themeProviderFunctions.switchMode();
              },
              icon: Icon(
                themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
              ));
        }),
      ]),
      body:
          Consumer<GamesProvider>(builder: (context, gamesProviderListener, _) {
        return gamesProviderListener.isFailed
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("ERROR "), Icon(Icons.error)],
                ),
              )
            : GridView.builder(
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
                                  gameId:
                                      gamesProviderListener.games[index].id)));
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
            gamesProviderFunctions.getGames(navIndex == 0
                ? 'https://www.freetogame.com/api/games'
                : navIndex == 1
                    ? 'https://www.freetogame.com/api/games?platform=pc'
                    : 'https://www.freetogame.com/api/games?platform=browser');
          });

          // fetchGames();
        }),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {}, child: Text(games.length.toString())),
    );
  }
}
