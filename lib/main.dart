import 'package:flutter/material.dart';
import 'package:free_to_play_challange/providers/games_provider.dart';
import 'package:free_to_play_challange/providers/them_provider.dart';
import 'package:free_to_play_challange/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GamesProvider>(
            create: (context) => GamesProvider()),
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor:
                themeProvider.isDark ? Colors.black87 : Colors.white,
            appBarTheme: AppBarTheme(
                backgroundColor:
                    themeProvider.isDark ? Colors.black45 : Colors.deepPurple),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor:
                    themeProvider.isDark ? Colors.black45 : Colors.white),
            unselectedWidgetColor:
                themeProvider.isDark ? Colors.white54 : Colors.black54,
            primarySwatch: Colors.deepPurple,
          ),
          home: const HomeScreen(),
        );
      }),
    );
  }
}
