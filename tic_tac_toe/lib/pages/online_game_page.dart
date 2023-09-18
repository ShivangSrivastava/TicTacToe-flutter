// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web_socket_channel/io.dart';

class OnlineGamePage extends StatefulWidget {
  final String gameCode;
  const OnlineGamePage({
    Key? key,
    required this.gameCode,
  }) : super(key: key);

  @override
  State<OnlineGamePage> createState() => _OnlineGamePageState();
}

class _OnlineGamePageState extends State<OnlineGamePage> {
  late IOWebSocketChannel channel;

  @override
  void initState() {
    channel = IOWebSocketChannel.connect(
        'ws://192.168.212.10:8000/${widget.gameCode}');
    channel.stream.listen((message) {
      try {
        Map<String, dynamic> data = json.decode(message);
        xScore = data["xScore"];
        oScore = data["oScore"];
        turn = data["turn"];
        msg = data["msg"];
        board = data["board"];
      } catch (e) {
        return;
      }
    });
    socketEvent();
    super.initState();
  }

  socketEvent() {
    channel.stream.listen((message) {
      try {
        Map<String, dynamic> data = json.decode(message);
        dataStreamController.add(data);
      } catch (e) {
        return;
      }
    });
  }

  late int xScore;
  late int oScore;
  late String turn;
  late String msg;
  late List<String> board;
  StreamController<Map<String, dynamic>> dataStreamController =
      StreamController<Map<String, dynamic>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.gameCode.text.make(),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
          stream: dataStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              xScore = data?["xScore"];
              oScore = data?["oScore"];
              turn = data?["turn"];
              msg = data?["msg"];
              board = data?["board"];
              return [
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
                        if (msg != "X wins" &&
                            msg != "O wins" &&
                            msg != "Tie") {
                          if (board[index].isEmpty) {
                            board[index] = turn.capitalized;
                            channel.sink.add("$index");
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
                        child: board[index].text.xl2.amber400.make(),
                      ),
                    );
                  },
                ).p32().expand(),
                const Spacer(),
                msg.text.blue500.make().py24()
              ].vStack().whFull(context);
            } else {
              return const CircularProgressIndicator().centered();
            }
          }),
    );
  }
}
