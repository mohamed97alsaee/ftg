import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:free_to_play_challange/models/single_game_model.dart';
import 'package:http/http.dart' as http;

class SingleGameScreen extends StatefulWidget {
  const SingleGameScreen({super.key, required this.gameId});
  final int gameId;
  @override
  State<SingleGameScreen> createState() => _SingleGameScreenState();
}

class _SingleGameScreenState extends State<SingleGameScreen> {
  late SingleGameModel singleGameModel;
  bool isLoading = false;
  bool expanDec = false;
  fetchSingleGame() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
        Uri.parse('https://www.freetogame.com/api/game?id=${widget.gameId}'));

    if (response.statusCode == 200) {
      // print(response.body);
      setState(() {
        singleGameModel = SingleGameModel.fromJson(json.decode(response.body));
      });
    } else {
      print("FAILED");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchSingleGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        height: size.height * 0.33,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25)),
                          child: Image.network(
                            singleGameModel.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: SafeArea(
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            singleGameModel.title,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expanDec = !expanDec;
                            });
                          },
                          child: SizedBox(
                            width: size.width,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    singleGameModel.shortDescription,
                                    maxLines: expanDec ? 10 : 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!expanDec)
                                  const Text(
                                    "see more",
                                  )
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(),
                        ),
                        Text(
                          "Publisher : ${singleGameModel.publisher}",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(),
                        ),
                        Text(
                          "Platform : ${singleGameModel.platform}",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(),
                        ),
                        Text(
                          "Developer : ${singleGameModel.developer}",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(),
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: singleGameModel.screenshots.length,
                            itemBuilder: ((context, index) {
                              return GridTile(
                                child: Image.network(
                                  singleGameModel.screenshots[index].image,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                ),
                              );
                            })),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(),
                        ),
                        Text(singleGameModel.description)
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
