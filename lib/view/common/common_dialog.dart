import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CommonDialog extends StatelessWidget {
  final String textContent;
  final VoidCallback onClick;

  const CommonDialog({
    required this.textContent,
    required this.onClick,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))
      ),
      actionsPadding: const EdgeInsets.only(top: 10),
      title: const Text(""),
      content: Text(textContent,style: const TextStyle(color: Colors.black),textAlign: TextAlign.center,),
      actions: <Widget>[
        const Divider(height: 1, color: Color(0xFFE3E3E3)),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  child: const Text('취소',style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  onClick();
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  decoration: const BoxDecoration(
                    color: AppColors.main700,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: const Text('확인',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                ),
              ),
            ),
          ],
        )
      ],

    );
  }

}
