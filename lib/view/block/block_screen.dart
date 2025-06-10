import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlockScreen extends StatelessWidget {
  const BlockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("block.title".tr),
      ),
    );
  }

}
