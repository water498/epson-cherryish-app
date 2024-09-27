
import 'package:flutter/material.dart';

class QrScanScreen extends StatelessWidget {
  const QrScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}



// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:seeya/constants/app_colors.dart';
// import 'package:seeya/constants/app_themes.dart';
//
// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});
//
//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }
//
// class _QrScanScreenState extends State<QrScanScreen>{
//
//   final MobileScannerController controller = MobileScannerController(
//     formats: const [BarcodeFormat.qrCode],
//   );
//
//   @override
//   Future<void> dispose() async {
//     super.dispose();
//     await controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final scanWindow = Rect.fromCenter(
//       center: MediaQuery.sizeOf(context).center(Offset.zero),
//       width: 200,
//       height: 200,
//     );
//
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         forceMaterialTransparency: true,
//         automaticallyImplyLeading: false,
//         title: Text("QR스캔", style: AppThemes.headline04.copyWith(color: Colors.white, height: 0),),
//         centerTitle: true,
//         actions: [
//           GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),)
//           ),
//           const SizedBox(width: 16,),
//         ],
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           MobileScanner(
//             controller: controller,
//             fit: BoxFit.cover,
//             scanWindow: scanWindow,
//             errorBuilder: (context, error, child) {
//               print("error ::: ${error}");
//               return Text("error ::: ${error}");
//             },
//             onDetect: (barcodes) {
//               Fluttertoast.showToast(msg: "barcodes founded !!!");
//             },
//           ),
//           ValueListenableBuilder(
//             valueListenable: controller,
//             builder: (context, value, child) {
//               if (!value.isInitialized || !value.isRunning || value.error != null) {
//                 return const SizedBox();
//               }
//
//               return CustomPaint(
//                 painter: ScannerOverlay(scanWindow: scanWindow),
//               );
//             },
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: SafeArea(
//               child: Column(
//                 children: [
//                   Text("QR코드를 스캔하세요.", style: AppThemes.headline04.copyWith(color: Colors.white)),
//                   const SizedBox(height: 8,),
//                   Text("QR코드를 사각형 영역에 맞추면\n자동으로 인식됩니다.", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),textAlign: TextAlign.center,),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//
//
// }
//
//
//
//
//
//
//
//
//
// class ScannerOverlay extends CustomPainter {
//   const ScannerOverlay({
//     required this.scanWindow,
//     this.borderRadius = 12.0,
//   });
//
//   final Rect scanWindow;
//   final double borderRadius;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // TODO: use `Offset.zero & size` instead of Rect.largest
//     // we need to pass the size to the custom paint widget
//     final backgroundPath = Path()..addRect(Rect.largest);
//
//     final cutoutPath = Path()
//       ..addRRect(
//         RRect.fromRectAndCorners(
//           scanWindow,
//           topLeft: Radius.circular(borderRadius),
//           topRight: Radius.circular(borderRadius),
//           bottomLeft: Radius.circular(borderRadius),
//           bottomRight: Radius.circular(borderRadius),
//         ),
//       );
//
//     final backgroundPaint = Paint()
//       ..color = Colors.black.withOpacity(0.5)
//       ..style = PaintingStyle.fill
//       ..blendMode = BlendMode.dstOut;
//
//     final backgroundWithCutout = Path.combine(
//       PathOperation.difference,
//       backgroundPath,
//       cutoutPath,
//     );
//
//     final borderPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4.0;
//
//     final borderRect = RRect.fromRectAndCorners(
//       scanWindow,
//       topLeft: Radius.circular(borderRadius),
//       topRight: Radius.circular(borderRadius),
//       bottomLeft: Radius.circular(borderRadius),
//       bottomRight: Radius.circular(borderRadius),
//     );
//
//     // First, draw the background,
//     // with a cutout area that is a bit larger than the scan window.
//     // Finally, draw the scan window itself.
//     canvas.drawPath(backgroundWithCutout, backgroundPaint);
//     canvas.drawRRect(borderRect, borderPaint);
//   }
//
//   @override
//   bool shouldRepaint(ScannerOverlay oldDelegate) {
//     return scanWindow != oldDelegate.scanWindow ||
//         borderRadius != oldDelegate.borderRadius;
//   }
// }
