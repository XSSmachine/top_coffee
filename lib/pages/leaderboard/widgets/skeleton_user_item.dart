import 'package:flutter/material.dart';

import '../../../utils/dimensions.dart';

class SkeletonUserItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width10),
        child: Row(
          children: [
            Skeleton(
                width: Dimensions.radius30 * 2,
                height: Dimensions.radius30 * 2,
                shape: BoxShape.circle),
            SizedBox(width: Dimensions.width10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(width: 120, height: 20),
                  SizedBox(height: Dimensions.height10 / 2),
                  Skeleton(width: 80, height: 16),
                ],
              ),
            ),
            Skeleton(width: 60, height: 20),
          ],
        ),
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final BoxShape shape;

  const Skeleton({
    Key? key,
    required this.width,
    required this.height,
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: shape,
        borderRadius:
            shape == BoxShape.rectangle ? BorderRadius.circular(8) : null,
      ),
    );
  }
}
