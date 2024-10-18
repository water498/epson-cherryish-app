import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seeya/constants/app_colors.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/constants/app_secret.dart';
import 'package:seeya/constants/app_themes.dart';
import 'package:seeya/constants/seeya_frame_configs.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/service/services.dart';
import 'package:seeya/utils/format_utils.dart';
import 'package:share_plus/share_plus.dart';

class EventDetailScreen extends GetView<EventDetailController> {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide > 600;


    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            controller: controller.scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                Obx(() {

                  var isExpanded = controller.isAppBarExpanded.value;
                  var event = controller.event.value;


                  return SliverAppBar(
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarBrightness: isExpanded? Brightness.dark : Brightness.light,
                    ),
                    pinned: true,
                    shape: Border(
                      bottom: BorderSide(
                        color: AppColors.blueGrey600,
                        width: isExpanded ? 0 : 2,
                      ),
                    ),
                    leadingWidth: 64,
                    leading: Row(
                      children: [
                        const SizedBox(width: 16,),
                        GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: SvgPicture.asset("assets/image/ic_back.svg", colorFilter: ColorFilter.mode(isExpanded ? Colors.white : AppColors.blueGrey100, BlendMode.srcIn))
                        ),
                      ],
                    ),
                    title: Text(isExpanded ? "": event?.event_name ?? "", style: AppThemes.headline04.copyWith(color: AppColors.blueGrey000, height: 0),textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,),
                    centerTitle: true,

                    actions: [
                      Obx(() {
                        if(controller.event.value == null) return const SizedBox();

                        return GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRouter.qr_share, arguments: controller.event.value);
                            },
                            child: SvgPicture.asset("assets/image/ic_share.svg", colorFilter: ColorFilter.mode(isExpanded ? Colors.white : AppColors.blueGrey100, BlendMode.srcIn))
                        );
                      },),
                      const SizedBox(width: 16,),
                    ],

                    expandedHeight: (MediaQuery.of(context).size.width * controller.backgroundRatio) - kToolbarHeight,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [

                          if(event != null)
                          CachedNetworkImage(
                            imageUrl: Uri.encodeFull("${AppSecret.s3url}${event.thumbnail_image_filepath}"),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset("assets/image/loading02.gif"),
                          ),

                          Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  stops: [0.5,1.0],
                                  colors: [Color(0x00000000), Color(0xff000000)],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },)

              ];
            },
            body: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Obx(() {

                var event = controller.event.value;

                return ListView(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {


                          // 제일 긴 텍스트 가로 크기 측정
                          double maxLabelWidth = 0.0;

                          final textPainter = TextPainter(
                            text: TextSpan(text: "인화 금액", style: AppThemes.bodyMedium.copyWith(fontFamily: "DungGeunMo"),),
                            maxLines: 1,
                            textDirection: TextDirection.ltr,
                          )..layout();

                          maxLabelWidth =  textPainter.size.width + 12; // 오른쪽 패딩 추가

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event?.event_name ?? "", style: AppThemes.headline03.copyWith(color: AppColors.blueGrey100),),
                              Text(event?.place_name ?? "", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),),
                              const SizedBox(height: 24,),
                              Row(
                                children: [
                                  SizedBox(
                                      width: maxLabelWidth,
                                      child: Text("인화 금액", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)
                                  ),
                                  Expanded(child: Text("${event?.need_using_fee == true ? 0: FormatUtils.formatWithComma(3000)}원", style: AppThemes.headline02.copyWith(color: AppColors.primary400),)),
                                ],
                              ),
                              const SizedBox(height: 4,),
                              Row(
                                children: [
                                  SizedBox(
                                    width: maxLabelWidth,
                                    child: Text("기간", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${FormatUtils.formatDate01(event?.start_date) ?? ""} - ${FormatUtils.formatDate01(event?.end_date) ?? ""}",
                                      style: AppThemes.headline05.copyWith(color: AppColors.blueGrey300),
                                    )
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: maxLabelWidth,
                                      child: Text("주소", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),)
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${event?.address ?? ""} ${event?.address_detail ?? ""}", style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey300),),
                                        GestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(text: "${event?.address ?? ""} ${event?.address_detail ?? ""}"));
                                              Fluttertoast.showToast(msg: "복사되었습니다.");
                                            },
                                            child: Text("주소 복사", style: AppThemes.bodySmall.copyWith(color: AppColors.primary400),)
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const Divider(height: 12, thickness: 12, color: AppColors.blueGrey800,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {

                          bool isFinishedEvent = false;

                          if(controller.event.value != null && controller.event.value!.end_date != null){
                            isFinishedEvent = DateTime.now().isAfter(controller.event.value!.end_date!);
                          }

                          return Container(
                            margin: const EdgeInsets.only(left: 24, right: 24, top: 20 ,bottom: 16),
                            child: Text(isFinishedEvent ? "종료된 이벤트입니다." : "프레임을 선택해주세요.", style: AppThemes.bodyMedium.copyWith(color: isFinishedEvent ? AppColors.blueGrey400 : AppColors.blueGrey100),),
                          );
                        },),
                        SizedBox(
                          height: isTablet ? 400 : 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.eventFrameList.length,
                            itemBuilder: (context, index) {

                              var frame = controller.eventFrameList[index];

                              return Padding(
                                padding: EdgeInsets.only(left: index == 0 ? 24 : 6, right: index == controller.eventFrameList.length - 1 ? 24 : 6),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () async {

                                    bool isFinishedEvent = true;

                                    if(controller.event.value != null && controller.event.value!.end_date != null){
                                      isFinishedEvent = !DateTime.now().isBefore(controller.event.value!.end_date!);
                                    }

                                    if(isFinishedEvent) {
                                      Fluttertoast.showToast(msg: "종료된 이벤트입니다.");
                                      return;
                                    }

                                    if(event == null) return;

                                    var selectedFrameFilters = controller.eventFilterList.where((filter) => filter.event_editor_frame_uid == frame.uid,).toList();

                                    Get.toNamed(
                                        AppRouter.decorate_frame,
                                        arguments: {
                                          "event": event,
                                          "event_frame": frame,
                                          "event_filters": selectedFrameFilters,
                                        }
                                    );

                                  },
                                  child: AspectRatio(
                                    aspectRatio: SeeyaFrameConfigs.frameWidth / SeeyaFrameConfigs.frameHeight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.blueGrey800,
                                          border: Border.all(
                                              color: AppColors.blueGrey700,
                                              width: 2
                                          )
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: Uri.encodeFull("${AppSecret.s3url}${frame.preview_image_filepath}"),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Image.asset("assets/image/loading02.gif"),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 100,),

                      ],
                    )

                  ],
                );
              },),
            ),
          )
        ],
      ),
    );
  }

}
