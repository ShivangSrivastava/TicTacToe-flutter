// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web_socket_channel/io.dart';
import '../../pages/online_game_page.dart';
import '../../services/get_game_code.dart';

class CreateGame extends StatefulWidget {
  const CreateGame({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateGame> createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  String? gameCode;

  Future setGameCode() async {
    gameCode = await getGameCode();
    setState(() {});
  }

  gotoGamePage(String gameCode) {
    if (gameCode.isNotEmpty) {
      context.nextPage(OnlineGamePage(
        gameCode: gameCode,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(
        CupertinoIcons.add,
        color: Vx.green400,
      ),
      style: OutlinedButton.styleFrom(
        padding: Vx.m20,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const CircularProgressIndicator().centered(),
        );
        setGameCode().then((value) {
          final channel =
              IOWebSocketChannel.connect('ws://192.168.212.10:8000/$gameCode');
          channel.stream.listen((message) {
            if (message == "joined") {
              gotoGamePage(gameCode!);
            } 
          });

          Navigator.pop(context);
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Waiting for opponent",
                  textScaleFactor: 0.5,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text('Game code : $gameCode '),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('QR'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => QrImageView(
                          data: gameCode!,
                          version: QrVersions.auto,
                          backgroundColor: Vx.black,
                          semanticsLabel: gameCode!,
                          padding: Vx.m32,
                          dataModuleStyle: const QrDataModuleStyle(
                            color: Vx.red400,
                            dataModuleShape: QrDataModuleShape.circle,
                          ),
                          eyeStyle: const QrEyeStyle(
                            color: Vx.red400,
                            eyeShape: QrEyeShape.circle,
                          ),
                        ).centered().px64(),
                      );
                    },
                  ),
                  TextButton(
                    child: const Text('Copy'),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: "$gameCode"))
                          .then((value) => VxToast.show(context,
                              msg: "Copied to clipboard", textSize: 10));
                    },
                  ),
                ],
              );
            },
          );
        });
      },
      label: "Create game".text.green400.sm.make(),
    ).py20();
  }
}
