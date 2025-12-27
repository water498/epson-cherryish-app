import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../core/config/app_colors.dart';
import '../../core/config/app_themes.dart';
import '../../controller/controllers.dart';

class SearchListItem extends GetView<SearchScreenController> {

  final VoidCallback onTap;
  final VoidCallback onDelete;
  final String title;
  final String subTitle;
  final bool isEvent;
  final bool isFromPref;


  const SearchListItem({
    required this.onTap,
    required this.onDelete,
    required this.title,
    required this.subTitle,
    required this.isEvent,
    required this.isFromPref,
    super.key
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(isEvent ? "assets/image/ic_place.svg" : "assets/image/ic_search.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey300, BlendMode.srcIn)),
            Expanded(child: Obx(() {

              var query = controller.searchText.value;
              final textSpans = _highlightText(query);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: textSpans),
                  ),
                  if(isEvent && subTitle.isNotEmpty)
                  Text(subTitle, style: AppThemes.bodySmall.copyWith(color: AppColors.blueGrey400), maxLines: 1, overflow: TextOverflow.ellipsis,)
                ],
              );
            },)),
            if(isFromPref)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                onDelete();
              },
              child: SvgPicture.asset("assets/image/ic_close.svg", colorFilter: const ColorFilter.mode(AppColors.blueGrey500, BlendMode.srcIn)),
            ),
          ],
        ),
      ),
    );
  }


  List<InlineSpan> _highlightText(String query) {
    final List<InlineSpan> spans = [];
    final RegExp regExp = RegExp(RegExp.escape(query), caseSensitive: false);
    final matches = regExp.allMatches(title);

    int start = 0;
    for (final match in matches) {
      if (start < match.start) {
        spans.add(TextSpan(
            text: title.substring(start, match.start),
            style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100, fontFamily: "DungGeunMo", height: 1)
        ));
      }
      spans.add(TextSpan(
          text: title.substring(match.start, match.end),
          style: AppThemes.bodyMedium.copyWith(color: AppColors.primary400, fontFamily: "DungGeunMo", height: 1)
      ));
      start = match.end;
    }
    if (start < title.length) {
      spans.add(TextSpan(
        text: title.substring(start),
        style: AppThemes.bodyMedium.copyWith(color: AppColors.blueGrey100, fontFamily: "DungGeunMo", height: 1)
      ));
    }
    return spans;
  }


}
