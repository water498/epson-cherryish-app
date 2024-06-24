import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_router.dart';


class PhotoListScreen extends StatelessWidget {
  const PhotoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Get.toNamed(AppRouter.purchase);
                    },
                    child: Container(
                      color: AppColors.grey100,
                      child: Column(
                        children: [
                          CachedNetworkImage(imageUrl: "https://i.pinimg.com/564x/b5/e6/7e/b5e67ecf906fd67c8860098a7bba1c33.jpg", fit: BoxFit.contain,),
                          Text("title"),
                          Text("subtitle"),
                        ],
                      ),
                    )
                );
              },
            ),
          )
        ],
      ),
    );
  }

}
