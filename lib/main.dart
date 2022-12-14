import 'package:flutter/material.dart';
import 'package:free_to_play_challange/providers/auth_provider.dart';
import 'package:free_to_play_challange/providers/games_provider.dart';
import 'package:free_to_play_challange/providers/them_provider.dart';
import 'package:free_to_play_challange/screens/auth_screens/login_screen.dart';
import 'package:free_to_play_challange/screens/main_screens/home_screen.dart';
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
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
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
          home: const ScreenRouter(),
        );
      }),
    );
  }
}

class ScreenRouter extends StatefulWidget {
  const ScreenRouter({super.key});

  @override
  State<ScreenRouter> createState() => _ScreenRouterState();
}

class _ScreenRouterState extends State<ScreenRouter> {
  @override
  void initState() {
        Provider.of<AuthProvider>(context, listen: false).start();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      return authProvider.isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : authProvider.isLogedIn
              ? const HomeScreen()
              : const LoginScreen();
    });
  }
}
