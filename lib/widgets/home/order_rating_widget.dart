import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CoffeeRatingWidget extends StatelessWidget {
  final double initialRating;
  final int itemCount;
  final Color starColor;
  final Color buttonColor;
  final String buttonText;
  final double iconSize;
  final double spacing;
  final Function(double) onRatingUpdate;
  final VoidCallback onRatingSubmit;

  const CoffeeRatingWidget({
    super.key,
    this.initialRating = 3,
    this.itemCount = 5,
    this.starColor = Colors.amberAccent,
    this.buttonColor = Colors.blue,
    this.buttonText = 'Submit your rating',
    this.iconSize = 30,
    this.spacing = 20,
    required this.onRatingUpdate,
    required this.onRatingSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RatingBar.builder(
            initialRating: initialRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: itemCount,
            itemSize: iconSize,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: starColor,
            ),
            onRatingUpdate: onRatingUpdate,
          ),
          SizedBox(height: spacing),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: onRatingSubmit,
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
