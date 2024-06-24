import 'package:flutter/material.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.lightGreen,
          ),
          Text("출력 가능한 프린터가 없습니다."),
        ],
      ),
    );
  }

}
