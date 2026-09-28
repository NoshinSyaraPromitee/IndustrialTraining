import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taskboard/core/theme/trello.dart';

class BoardShimmer extends StatelessWidget {
  const BoardShimmer({super.key});

  Widget _bar(double w, double h) => Container(
    width: w,
    height: h,
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
  );

  Widget _column(List<double> cards) => Container(
    width: 300,
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Trello.list,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Shimmer.fromColors(
      baseColor: Trello.card,
      highlightColor: const Color(0xFF3B444C),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bar(110, 16),
          for (final h in cards) _bar(double.infinity, h),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _column([44, 60, 44]),
        _column([52, 44]),
        _column([44]),
      ],
    ),
  );
}
