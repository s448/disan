import 'package:disan/Model/dan_model.dart';
import 'package:disan/View/Widgets/grid_tile_tem.dart';
import 'package:disan/View/Widgets/timelineWidgets/post_widget.dart';
import 'package:flutter/material.dart';

class ActiveDansGridView extends StatelessWidget {
  const ActiveDansGridView(
      {super.key, required this.activeDans, required this.isGListView});
  final List<DanModel> activeDans;
  final bool isGListView;
  @override
  Widget build(BuildContext context) {
    return isGListView
        ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: activeDans.length,
            itemBuilder: (BuildContext context, int index) {
              final item = activeDans[index];
              return PostWidget(
                dan: item,
                usedInCartPage: false,
                usedInOrdersPage: false,
                usedInRatingPage: true,
              );
            },
          )
        : GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 6.0,
            ),
            itemCount: activeDans.length,
            itemBuilder: (BuildContext context, int index) {
              final item = activeDans[index];
              return GridTileItem(
                name: item.description.toString(),
                img: item.imgs![0],
                networking: true,
              );
            },
          );
  }
}
