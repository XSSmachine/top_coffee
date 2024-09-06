import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateOrderWidget extends StatefulWidget {
  final Function(double) onSubmit;

  const RateOrderWidget({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _RateOrderWidgetState createState() => _RateOrderWidgetState();
}

class _RateOrderWidgetState extends State<RateOrderWidget> {
  double _rating = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate Your Order'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('How many stars would you like to give?'),
          SizedBox(height: 20),
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text('Submit'),
          onPressed: () {
            widget.onSubmit(_rating);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
