import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_themes.dart';
import '../../controller/controllers.dart';

class SearchListItem extends StatelessWidget {

  final VoidCallback onTap;
  final String eventName;
  final bool isPlace;
  final bool isRecorded;

  const SearchListItem({
    required this.onTap,
    required this.eventName,
    required this.isPlace,
    required this.isRecorded,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(SearchScreenController());


    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(isPlace ? "assets/image/ic_place.svg" : "assets/image/ic_search.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey300, BlendMode.srcIn)),
          Expanded(child: Obx(() {

            var query = controller.searchText.value;
            final textSpans = _highlightText(query);

            return RichText(
              text: TextSpan(children: textSpans),
            );
          },)),
          if(isRecorded)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Fluttertoast.showToast(msg: "삭제");
            },
            child: SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey500, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }


  List<InlineSpan> _highlightText(String query) {
    final List<InlineSpan> spans = [];
    final RegExp regExp = RegExp(RegExp.escape(query), caseSensitive: false);
    final matches = regExp.allMatches(eventName);

    int start = 0;
    for (final match in matches) {
      if (start < match.start) {
        spans.add(TextSpan(
            text: eventName.substring(start, match.start),
            style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100, fontFamily: "DungGeunMo", height: 1)
        ));
      }
      spans.add(TextSpan(
          text: eventName.substring(match.start, match.end),
          style: AppThemes.bodyMedium.copyWith(color: AppColors.primary400, fontFamily: "DungGeunMo", height: 1)
      ));
      start = match.end;
    }
    if (start < eventName.length) {
      spans.add(TextSpan(
        text: eventName.substring(start),
        style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100, fontFamily: "DungGeunMo", height: 1)
      ));
    }
    return spans;
  }


}
