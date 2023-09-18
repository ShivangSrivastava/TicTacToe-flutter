import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tic_tac_toe/widgets/join_game/button.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets/create_game/button.dart';
import '../widgets/play_offline_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasConnection = false;

  refreshInternet() async {
    hasConnection = await InternetConnectionChecker().hasConnection;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    refreshInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Tic Tac Toe".text.make(),
        actions: [
          IconButton(
              onPressed: refreshInternet, icon: const Icon(Icons.refresh))
        ],
      ),
      body: [
        Visibility(
            visible: !hasConnection,
            child: "You are offline!".text.red400.sm.make()),
        [
          const PlayOfflineWidget().py20(),
          Visibility(
            visible: hasConnection,
            child: const CreateGame(),
          ),
          Visibility(
            visible: hasConnection,
            child: const JoinGame(),
          ),
        ]
            .vStack(
              alignment: MainAxisAlignment.center,
              crossAlignment: CrossAxisAlignment.center,
            )
            .flexible()
      ].vStack().whFull(context),
    );
  }
}
