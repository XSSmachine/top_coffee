import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team_coffee/controllers/user_controller.dart';
import 'package:team_coffee/models/event_body_model.dart';
import 'package:team_coffee/widgets/event_type_chip.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/icon_and_text_widget.dart';

/// This class displays a form for creating new event
class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  String selectedTime = "10 min";
  int pendingTime = 10;
  int selectedButtonIndex = 1;
  Duration selectedDuration = const Duration(minutes: 10);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedEventType = "MIX"; // Default event type

  void _updateSelectedEventType(String newType) {
    setState(() {
      _selectedEventType = newType;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
                pendingTime = _formatDurationToInt(newDuration);
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

  int _formatDurationToInt(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return hours * 60 + minutes;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create new event'),
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Dimensions.height30,
                    right: Dimensions.height30,
                    top: Dimensions.height30 * 0.8),
                child: TextField(
                  controller: _titleController,
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /*EventTypeChip(
                        label: "MIX",
                        color: AppColors.redChipColor,
                        icon: Icons.fastfood,
                        selectedEventType: _selectedEventType,
                        onEventTypeChanged: _updateSelectedEventType),
                    const SizedBox(width: 8.0),*/
                  EventTypeChip(
                    label: "COFFEE",
                    color: AppColors.orangeChipColor,
                    icon: Icons.coffee,
                    selectedEventType: _selectedEventType,
                    onEventTypeChanged: _updateSelectedEventType,
                    firstSelected: "FOOD",
                  ),
                  const SizedBox(width: 8.0),
                  EventTypeChip(
                    label: "FOOD",
                    color: AppColors.greenChipColor,
                    icon: Icons.restaurant,
                    selectedEventType: _selectedEventType,
                    onEventTypeChanged: _updateSelectedEventType,
                    firstSelected: "FOOD",
                  ),
                  const SizedBox(width: 8.0),
                  EventTypeChip(
                    label: "BEVERAGE",
                    color: AppColors.blueChipColor,
                    icon: Icons.liquor,
                    selectedEventType: _selectedEventType,
                    onEventTypeChanged: _updateSelectedEventType,
                    firstSelected: "FOOD",
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height30),
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: TextField(
                  maxLines: 5,
                  controller: _descriptionController,
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
                  Text(
                    'Time until event starts: ',
                    style: TextStyle(fontSize: Dimensions.font20),
                  ),
                  GestureDetector(
                    onTap: _showTimerPicker,
                    child: Text(
                      selectedTime,
                      style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: Dimensions.font20),
                    ),
                  ),
                ],
              ),
              //Spacer(),
              SizedBox(height: Dimensions.height30 * 2),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final String profileId =
                        await userController.getProfileId();
                    final String title = _titleController.text.trim();
                    final String description =
                        _descriptionController.text.trim();
                    final String eventType = _selectedEventType;
                    //final String groupId = await userController.getGroupId(); // You need to provide a way to set this

                    if (title.isNotEmpty && description.isNotEmpty) {
                      print("PROFIL ID $profileId");
                      await Get.find<EventController>().createEvent(
                        EventBody(
                          //creatorId: profileId ,
                          time: pendingTime,
                          title: title,
                          description: description,
                          eventType: eventType,
                          //groupId: groupId,
                        ),
                      );
                      Get.back();
                      // Optionally, you can add a success message or navigation here
                    } else {
                      // Show an error message if title or description is empty
                      Get.snackbar('Error', 'Please fill in all fields');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.mainPurpleColor),
                  child: const Row(
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
        ),
      ),
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainBlueMediumColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(Dimensions.radius15 * 0.8),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: Dimensions.font16,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
