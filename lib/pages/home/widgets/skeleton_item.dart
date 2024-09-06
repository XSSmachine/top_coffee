import 'package:flutter/material.dart';

import '../../../utils/dimensions.dart';

class SkeletonEventItem extends StatelessWidget {
  const SkeletonEventItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: Dimensions.height20 * 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius15),
                topRight: Radius.circular(Dimensions.radius15),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimensions.height10 * 0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                Container(
                  width: double.infinity,
                  height: Dimensions.height20,
                  color: Colors.grey[300],
                ),
                SizedBox(height: Dimensions.height10 * 0.4),
                // Description placeholder
                Container(
                  width: double.infinity,
                  height: Dimensions.height15,
                  color: Colors.grey[300],
                ),
                SizedBox(height: Dimensions.height10 * 0.4),
                // Author placeholder
                Container(
                  width: Dimensions.width20 * 5,
                  height: Dimensions.height15,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
