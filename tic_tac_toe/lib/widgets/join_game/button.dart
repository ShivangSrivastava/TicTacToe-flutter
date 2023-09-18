import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web_socket_channel/io.dart';

import '../../pages/online_game_page.dart';

class JoinGame extends StatefulWidget {
  const JoinGame({super.key});

  @override
  State<JoinGame> createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const Icon(
        Icons.merge,
        color: Vx.blue400,
      ),
      style: OutlinedButton.styleFrom(
        padding: Vx.m20,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Join game",
                textScaleFactor: 0.5,
              ),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmptyOrNull) {
                      return "Game code can't be empty";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    errorMaxLines: 5,
                    hintText: "Game Code",
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    String scannedGameCode;
                    scannedGameCode = await FlutterBarcodeScanner.scanBarcode(
                        '#ff6666', 'Cancel', true, ScanMode.QR);
                    gotoGamePage(scannedGameCode);
                  },
                  child: const Text("Scan"),
                ),
                TextButton(
                  onPressed: () {
                    formKey.currentState?.validate();
                    gotoGamePage(controller.text);
                  },
                  child: const Text("Join"),
                ),
              ],
            );
          },
        );
      },
      label: "Join game".text.blue400.sm.make(),
    ).py20();
  }

  gotoGamePage(String gameCode) {
    final channel = IOWebSocketChannel.connect(
        'ws://192.168.212.10:8000/$gameCode'); // Replace with your WebSocket server address
    channel.sink.add("join");
    
    if (gameCode.isNotEmpty) {
      context.nextPage(OnlineGamePage(
        gameCode: gameCode,
      ));
    }
  }
}
