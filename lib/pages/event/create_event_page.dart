import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart' as client;
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:team_coffee/base/show_custom_snackbar.dart';
import 'package:team_coffee/controllers/notification_controller.dart';
import 'package:team_coffee/controllers/user_controller.dart';
import 'package:team_coffee/models/event_body_model.dart';
import 'package:team_coffee/widgets/event_type_chip.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/event_controller.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/string_resources.dart';

/// This class displays a form for creating new event
class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage>
    with TickerProviderStateMixin {
  final String webSocketUrl = AppConstants.BASE_SOCKET_URL;
  late client.StompClient _client;
  List<dynamic> messages = List.empty();
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  NotificationController notificationController =
      Get.find<NotificationController>();
  String selectedTime = "10 min";
  int pendingTime = 10;
  int selectedButtonIndex = 1;
  Duration selectedDuration = const Duration(minutes: 10);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedEventType = "MIX"; // Default event type

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late List<AnimationController> _fadeControllers;
  late List<Animation<double>> _fadeAnimations;

  late List<AnimationController> _slideControllers;
  late List<Animation<Offset>> _slideAnimations;

  void _updateSelectedEventType(String newType) {
    setState(() {
      _selectedEventType = newType;
    });
  }

  void onConnectCallback(StompFrame connectFrame) async {
    String profileId = await userController.getProfileId();
    _client.subscribe(
        destination: '/topic/orders/${profileId}', //topic/groups/groupId
        headers: {},
        callback: (frame) {
          print(frame.body);
          showCustomSnackBar(frame.body ?? "Null message");
          // Received a frame for this subscription
          messages = jsonDecode(frame.body!).reversed.toList();
        });
  }

  @override
  void initState() {
    super.initState();
    _client = client.StompClient(
        config: StompConfig(url: webSocketUrl, onConnect: onConnectCallback));
    _client.activate();

    _slideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    // Setup fade animations
    _fadeControllers = List.generate(
      6, // Number of rows to animate
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );
    _fadeAnimations = _fadeControllers
        .map(
            (controller) => Tween<double>(begin: 0, end: 1).animate(controller))
        .toList();

    // Start animations
    _slideController.forward();
    for (var i = 0; i < _fadeControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 200 * (i + 1)), () {
        _fadeControllers[i].forward();
      });
    }

    _slideControllers = List.generate(
      6, // Number of rows to animate
      (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800),
      ),
    );

    _slideAnimations = _slideControllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(-1, 0), // Start from left side of the screen
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.decelerate,
      ));
    }).toList();

    // Start the animations with a slight delay between each
    for (var i = 0; i < _slideControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        _slideControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _slideController.dispose();
    for (var controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showTimerPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: Dimensions.height20 * 12.5,
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
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.newEventTitle.tr),
          toolbarHeight: Dimensions.height20 * 3.5,
        ),
        body: Stack(
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.mainBlueColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius30),
                    topRight: Radius.circular(Dimensions.radius30),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: Dimensions.height30),
                      SlideTransition(
                        position: _slideAnimations[0],
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width15),
                          child: TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: AppStrings.pizzaHint.tr,
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      SlideTransition(
                        position: _slideAnimations[1],
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              EventTypeChip(
                                label: AppStrings.coffeeFilter.tr,
                                color: AppColors.orangeChipColor,
                                icon: Icons.coffee,
                                selectedEventType: _selectedEventType,
                                onEventTypeChanged: _updateSelectedEventType,
                                firstSelected: "FOOD",
                              ),
                              SizedBox(width: Dimensions.width15 / 3),
                              EventTypeChip(
                                label: AppStrings.foodFilter.tr,
                                color: AppColors.greenChipColor,
                                icon: Icons.restaurant,
                                selectedEventType: _selectedEventType,
                                onEventTypeChanged: _updateSelectedEventType,
                                firstSelected: "FOOD",
                              ),
                              SizedBox(width: Dimensions.width15 / 3),
                              EventTypeChip(
                                label: AppStrings.beverageFilter.tr,
                                color: AppColors.blueChipColor,
                                icon: Icons.liquor,
                                selectedEventType: _selectedEventType,
                                onEventTypeChanged: _updateSelectedEventType,
                                firstSelected: "FOOD",
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      SlideTransition(
                        position: _slideAnimations[2],
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.width15),
                          child: TextField(
                            maxLines: 5,
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: AppStrings.eventDescHint.tr,
                              filled: true,
                              fillColor: Colors.grey[300],
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height30),
                      SlideTransition(
                        position: _slideAnimations[3],
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTimeButton('5 min', 0),
                              _buildTimeButton('10 min', 1),
                              _buildTimeButton('15 min', 2),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height30),
                      SlideTransition(
                        position: _slideAnimations[4],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.timeUntilStart.tr,
                              style: TextStyle(
                                  fontSize: Dimensions.font20,
                                  color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: _showTimerPicker,
                              child: Text(
                                selectedTime,
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontSize: Dimensions.font20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Spacer(),
                      SizedBox(height: Dimensions.height30 * 2),
                      Center(
                        child: SlideTransition(
                          position: _slideAnimations[5],
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
                                      time: selectedDuration.inMinutes,
                                      title: title,
                                      description: description,
                                      eventType: eventType,
                                      //groupId: groupId,
                                    ),
                                    notificationController);
                                await Get.find<EventController>()
                                    .getActiveEvent2();
                                Navigator.pop(context);
                                // Optionally, you can add a success message or navigation here
                              } else {
                                // Show an error message if title or description is empty
                                Get.snackbar(AppStrings.errorMsg.tr,
                                    AppStrings.fillInAllFields.tr);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimensions.width30 * 1.2,
                                    vertical: Dimensions.height15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppStrings.createTitle.tr,
                                  style: TextStyle(
                                    fontSize: Dimensions.font16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mainBlueMediumColor,
                                  ),
                                ),
                                SizedBox(width: Dimensions.height15 / 2),
                                Icon(Icons.arrow_forward,
                                    color: AppColors.mainBlueMediumColor),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.height20, horizontal: Dimensions.height20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainBlueDarkColor : Colors.grey[300],
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
