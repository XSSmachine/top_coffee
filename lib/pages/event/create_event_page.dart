import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/dimensions.dart';
import '../../widgets/icon_and_text_widget.dart';

/**
 * This class displays a form for creating new event
 */
class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}
class _CreateEventPageState extends State<CreateEventPage> {
  String selectedTime = "10 min";
  int selectedButtonIndex = 1;
  Duration selectedDuration = Duration(minutes: 10);

  void _showTimerPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: selectedDuration,
            onTimerDurationChanged: (Duration newDuration) {
              setState(() {
                selectedDuration = newDuration;
                selectedTime = _formatDuration(newDuration);
                selectedButtonIndex = -1; // Unselect all buttons
              });
            },
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    return "${hours != "00" ? "$hours h " : ""}$minutes min";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text('Create new event'),
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: Dimensions.height30,right: Dimensions.height30,top: Dimensions.height30*0.8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Title',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: Dimensions.width10,),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Color(0xFFF0635A)),
                  ),
                  label: IconAndTextWidget(
                    icon: Icons.fastfood,
                    text: "Mix",
                    iconColor: Colors.white,
                  ),
                  backgroundColor: Color(0xFFF0635A),
                  onSelected: (bool value) {},
                ),
                SizedBox(width: 8.0),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Color(0xFFF59762)),
                  ),
                  label: IconAndTextWidget(
                    icon: Icons.coffee,
                    text: "Coffee",
                    iconColor: Colors.white,
                  ),
                  backgroundColor: Color(0xFFF59762),
                  onSelected: (bool value) {},
                ),
                SizedBox(width: 8.0),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Color(0xFF29D697)),
                  ),
                  label: IconAndTextWidget(
                    icon: IconData(0xec29, fontFamily: 'MaterialIcons'),
                    text: "Food",
                    iconColor: Colors.white,
                  ),
                  backgroundColor: Color(0xFF29D697),
                  onSelected: (bool value) {},
                ),
                SizedBox(width: 8.0),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Color(0xFF46CDFB)),
                  ),
                  label: IconAndTextWidget(
                    icon: IconData(0xe383, fontFamily: 'MaterialIcons'),
                    text: "Drinks",
                    iconColor: Colors.white,
                  ),
                  backgroundColor: Color(0xFF46CDFB),
                  onSelected: (bool value) {},
                ),
                SizedBox(width: 20.0),
              ],
            ),
          ),
          SizedBox(height: Dimensions.height30),
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Description',
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height45),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeButton('5 min', 0),
              _buildTimeButton('10 min', 1),
              _buildTimeButton('15 min', 2),
            ],
          ),
          SizedBox(height: Dimensions.height30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Time until event starts: ',
              style: TextStyle(fontSize: Dimensions.font20),),
              GestureDetector(
                onTap: _showTimerPicker,
                child: Text(
                  selectedTime,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                      fontSize: Dimensions.font20
                  ),
                ),
              ),
            ],
          ),
          //Spacer(),
          SizedBox(height:Dimensions.height30*2),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF4A43EC)
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CREATE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),

    ), onWillPop: () async {
      Navigator.pop(context);
      return false;
    },);
  }

  Widget _buildCategoryButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildTimeButton(String text, int index) {
    bool isSelected = selectedButtonIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedButtonIndex = index;
          selectedTime = text;
          selectedDuration = Duration(
            minutes: int.parse(text.split(' ')[0]),
          );
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF3D56F0): Colors.grey[300],
          borderRadius: BorderRadius.circular(Dimensions.radius15*0.8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: Dimensions.font16,
              fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }
}


