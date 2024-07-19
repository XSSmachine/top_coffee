import 'package:flutter/cupertino.dart';

import '../utils/dimensions.dart';

class StatsValueTitle extends StatelessWidget {
  final String title;
  final String dataValue;
  const StatsValueTitle({super.key, required this.title,required this.dataValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        SizedBox(height: Dimensions.height10/2,),
        Text(dataValue)
      ]

    );
  }
}
