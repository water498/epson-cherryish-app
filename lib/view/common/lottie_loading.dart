import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoading extends StatelessWidget {

  final String? text;

  const LottieLoading({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {

    final deviceWidth = MediaQuery.of(context).size.width;
    final circleSize = deviceWidth * 0.2;
    final lottieSize = circleSize * 4;

    return WillPopScope(
      // canPop: false,
      onWillPop: () async => false,

      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(circleSize * 0.1)),
                ),
                child: OverflowBox(
                  maxWidth: lottieSize,
                  maxHeight: lottieSize,
                  child: Image.asset("assets/image/loading.gif",width: lottieSize,height: lottieSize),
                  // child: Lottie.asset("assets/lottie/loading_cute.json",width: lottieSize,height: lottieSize)
                ),
              ),
              const SizedBox(height: 5,),
              Text(text ?? "", style: TextStyle(color: Colors.white),),
            ],
          ),
        )

      ),
    );
  }

}
