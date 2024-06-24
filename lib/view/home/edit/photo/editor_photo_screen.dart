import 'package:flutter/material.dart';

class EditorPhotoScreen extends StatelessWidget {
  const EditorPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.orange,
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.green,
                  ),
                )
              ],
            )
          ),
          Container(
            height: 100,
            color: Colors.indigoAccent,
          )
        ],
      ),
    );
  }

}
