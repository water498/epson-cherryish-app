import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_themes.dart';
import 'package:seeya/data/enum/enums.dart';

import '../../core/config/app_colors.dart';
import '../../controller/controllers.dart';


class SortKeyListBottomSheet extends StatefulWidget {

  final void Function(EventSortKeyEnum) onSelected;

  const SortKeyListBottomSheet({
    required this.onSelected,
    super.key
  });

  @override
  State<SortKeyListBottomSheet> createState() => _SortKeyListBottomSheetState();
}

class _SortKeyListBottomSheetState extends State<SortKeyListBottomSheet> {

  final sortKeyList = EventSortKeyEnum.values;

  @override
  Widget build(BuildContext context) {

    final mapTabController = Get.find<MapTabController>();

    return Container(
      color: Colors.white,
      child: Wrap(
        children: [
          const Divider(height: 2,color: AppColors.blueGrey600),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Container(width: 40, height: 4, color: AppColors.blueGrey600,),
                const SizedBox(height: 4,),
                Row(
                  children: [
                    Text("map_sort.title".tr, style: AppThemes.headline04.copyWith(color: AppColors.blueGrey000),),
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/image/ic_close.svg")
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortKeyList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {

                        mapTabController.searchSortKey.value = sortKeyList[index];
                        widget.onSelected(sortKeyList[index]);
                        Navigator.pop(context);

                      },
                      child: Obx(() {
                        return Container(
                          color: mapTabController.searchSortKey.value == sortKeyList[index] ? AppColors.primary900 : Colors.transparent,
                          child: Row(
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(sortKeyList[index].toDisplayString(), style: AppThemes.bodyMedium.copyWith(color: mapTabController.searchSortKey.value == sortKeyList[index] ? AppColors.primary400 : AppColors.blueGrey000),),
                              ),

                              const Expanded(child: SizedBox()),

                              if(mapTabController.searchSortKey.value == sortKeyList[index])
                                SvgPicture.asset("assets/image/ic_check.svg", colorFilter: ColorFilter.mode(AppColors.primary400, BlendMode.srcIn),),

                            ],
                          ),
                        );
                      },),
                    );
                  },
                ),
                const SizedBox(height: 35,),


              ],
            ),
          )
        ],
      ),
    );
  }

}





