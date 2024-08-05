import 'package:flutter/material.dart';
import 'package:team_coffee/utils/dimensions.dart';

import '../../utils/colors.dart';

class TimeSelectionWidget extends StatelessWidget {
  final Function(int) createBrewEvent;
  final VoidCallback onClose;

  const TimeSelectionWidget({
    super.key,
    required this.createBrewEvent,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.paraColor,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onClose,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(34.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "In how many minutes will you start brewing coffee?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTimeButton(5, "5 min"),
                    _buildTimeButton(10, "10 min"),
                    _buildTimeButton(15, "15 min"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTimeButton(int minutes, String label) {
    return ElevatedButton(
      onPressed: () {
        print("Trying to create new event");
        createBrewEvent(minutes);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.paraColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
