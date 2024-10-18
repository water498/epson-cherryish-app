import 'package:flutter/material.dart';

class BlockScreen extends StatelessWidget {
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("관리자에 의해 차단되었습니다."),
      ),
    );
  }

}
