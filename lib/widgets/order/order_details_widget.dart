import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team_coffee/utils/dimensions.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(left:Dimensions.height20,right:Dimensions.height20,bottom:Dimensions.height20,top: Dimensions.height10),
      decoration: BoxDecoration(
        color: Color(0xFF5669FF),
        borderRadius: BorderRadius.circular(Dimensions.radius15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MY ORDER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font20
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('CANCEL'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '• RIŽOTO PILETINA\n• MIX SALATA\n• KOLA',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'STATUS',
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimensions.font16
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'PENDING',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
