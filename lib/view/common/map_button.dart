import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';
import 'bouncing_button.dart';

class MapButton extends StatelessWidget {

  final IconData iconData;
  final VoidCallback onTap;

  const MapButton({
    super.key,
    required this.iconData,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return BouncingButton(
      onTap: () {
        onTap();
      },
      child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]
          ),
          child: Icon(iconData, color: AppColors.main700,)
      ),
    );
  }

}
