import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        context.nextAndRemoveUntilPage(const HomePage());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        "XO".text.xl4.make().box.gray800.p24.roundedFull.makeCentered(),
        Positioned(
          bottom: Vx.dp20,
          child: "Tic Tac Toe".text.make(),
        ),
      ].zStack(alignment: Alignment.bottomCenter),
    );
  }
}
