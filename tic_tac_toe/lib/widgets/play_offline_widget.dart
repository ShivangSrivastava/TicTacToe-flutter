import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/pages/offline_game_page.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayOfflineWidget extends StatelessWidget {
  const PlayOfflineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(
        CupertinoIcons.person_2_fill,
        color: Vx.amber400,
      ),
      style: OutlinedButton.styleFrom(
        padding: Vx.m20,
      ),
      onPressed: () {
        context.nextPage(const OfflineGamePage());
      },
      label: "Play offline".text.amber400.sm.make(),
    );
  }
}
