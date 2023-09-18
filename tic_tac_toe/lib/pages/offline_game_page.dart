import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class OfflineGamePage extends StatefulWidget {
  const OfflineGamePage({super.key});

  @override
  State<OfflineGamePage> createState() => _OfflineGamePageState();
}

class _OfflineGamePageState extends State<OfflineGamePage> {
  int xScore = 0;
  int oScore = 0;
  bool xTurn = true;
  String winner = "";
  bool isTie = false;
  bool disabledButtons = false;

  List<String> boardPosition = List.generate(9, (index) => "");

  checkWinner() {
    if (boardPosition[0] == boardPosition[1] &&
        boardPosition[0] == boardPosition[2] &&
        boardPosition[0].isNotEmpty) {
      winner = boardPosition[0];
    }
    if (boardPosition[3] == boardPosition[4] &&
        boardPosition[3] == boardPosition[5] &&
        boardPosition[3].isNotEmpty) {
      winner = boardPosition[3];
    }
    if (boardPosition[6] == boardPosition[7] &&
        boardPosition[6] == boardPosition[8] &&
        boardPosition[6].isNotEmpty) {
      winner = boardPosition[6];
    }
    if (boardPosition[0] == boardPosition[3] &&
        boardPosition[0] == boardPosition[6] &&
        boardPosition[0].isNotEmpty) {
      winner = boardPosition[0];
    }
    if (boardPosition[1] == boardPosition[4] &&
        boardPosition[1] == boardPosition[7] &&
        boardPosition[1].isNotEmpty) {
      winner = boardPosition[1];
    }
    if (boardPosition[2] == boardPosition[5] &&
        boardPosition[2] == boardPosition[8] &&
        boardPosition[2].isNotEmpty) {
      winner = boardPosition[2];
    }
    if (boardPosition[0] == boardPosition[4] &&
        boardPosition[0] == boardPosition[8] &&
        boardPosition[0].isNotEmpty) {
      winner = boardPosition[0];
    }
    if (boardPosition[2] == boardPosition[4] &&
        boardPosition[2] == boardPosition[6] &&
        boardPosition[2].isNotEmpty) {
      winner = boardPosition[2];
    }

    if (winner.isEmpty) {
      if (!boardPosition.contains("")) {
        isTie = true;
      }
    }
    updateScore();
  }

  updateScore() {
    if (winner.isNotEmpty) {
      disabledButtons = true;
      setState(() {});
      (winner == "X") ? xScore = xScore + 1 : oScore = oScore + 1;

      VxToast.show(context, msg: "$winner wins");
      Future.delayed(
        const Duration(seconds: 1),
        () {
          winner = "";
          boardPosition = List.generate(9, (index) => "");
          disabledButtons = false;

          setState(() {});
        },
      );
    } else if (isTie) {
      disabledButtons = true;
      setState(() {});
      VxToast.show(context, msg: "Its tie");
      Future.delayed(
        const Duration(seconds: 1),
        () {
          isTie = false;
          boardPosition = List.generate(9, (index) => "");
          setState(() {});
          disabledButtons = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: [
        [
          "Player X\n$xScore".text.center.make().expand(),
          "Player O\n$oScore".text.center.make().expand(),
        ].hStack(),
        GridView.builder(
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (!disabledButtons) {
                  if (boardPosition[index].isEmpty) {
                    boardPosition[index] = xTurn ? "X" : "O";
                    xTurn = !xTurn;
                    checkWinner();
                    setState(() {});
                  }
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: ([0, 1, 3, 4, 6, 7].contains(index))
                        ? const BorderSide(
                            color: Vx.gray800,
                            width: 5,
                          )
                        : BorderSide.none,
                    left: ([1, 2, 4, 5, 7, 8].contains(index))
                        ? const BorderSide(
                            color: Vx.gray800,
                            width: 5,
                          )
                        : BorderSide.none,
                    top: ([3, 4, 5, 6, 7, 8].contains(index))
                        ? const BorderSide(
                            color: Vx.gray800,
                            width: 5,
                          )
                        : BorderSide.none,
                    bottom: ([0, 1, 2, 3, 4, 5].contains(index))
                        ? const BorderSide(
                            color: Vx.gray800,
                            width: 5,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: boardPosition[index].text.xl2.amber400.make(),
              ),
            );
          },
        ).p32().expand()
      ].vStack().whFull(context),
    );
  }
}
