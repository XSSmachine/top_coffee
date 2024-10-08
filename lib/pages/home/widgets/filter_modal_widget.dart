import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:team_coffee/controllers/event_controller.dart';
import '../../../models/filter_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class FilterModal extends StatefulWidget {
  final Function(EventFilters) onApplyFilters;

  const FilterModal({Key? key, required this.onApplyFilters}) : super(key: key);

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  EventController eventController = Get.find<EventController>();
/*  String selectedEventType = 'ALL';
  List<String> selectedEventStatus = ['PENDING'];
  String selectedTimeDate = '';*/

  final Map<String, Color> eventTypeColors = {
    'ALL': AppColors.redChipColor,
    'COFFEE': AppColors.orangeChipColor,
    'FOOD': AppColors.greenChipColor,
    'BEVERAGE': AppColors.blueChipColor,
  };

  final Map<String, IconData> eventTypeIcons = {
    'ALL': Icons.fastfood,
    'COFFEE': Icons.coffee,
    'FOOD': Icons.restaurant,
    'BEVERAGE': Icons.liquor,
  };

  final Map<String, IconData> statusIcons = {
    'PENDING': Icons.pending_actions,
    'IN_PROGRESS': Icons.hourglass_top,
    'COMPLETED': Icons.verified_rounded,
    'CANCELLED': Icons.cancel,
    // Add more status-icon mappings as needed
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter'.tr,
            style: TextStyle(
                fontSize: Dimensions.font26, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: Dimensions.height15),
          _buildEventTypeSelection(),
          SizedBox(height: Dimensions.height20),
          Text(
            "Event status".tr,
            style: TextStyle(
                fontSize: Dimensions.font16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: Dimensions.height15),
          _buildEventStatusSelection(),
          SizedBox(height: Dimensions.height20),
          Text(
            "Time & Date".tr,
            style: TextStyle(
                fontSize: Dimensions.font16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          _buildTimeDateSelection(),
          SizedBox(height: Dimensions.height30), //_buildPriceRangeSelection(),
          _buildActionButtons(),
          SizedBox(height: Dimensions.height30),
        ],
      ),
    );
  }

  Widget _buildEventTypeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildEventTypeOption('ALL'),
        _buildEventTypeOption('COFFEE'),
        _buildEventTypeOption('FOOD'),
        _buildEventTypeOption('BEVERAGE'),
      ],
    );
  }

  Widget _buildEventTypeOption(String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          eventController.selectedEventType.value = type;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: eventController.selectedEventType.value == type
                ? eventTypeColors[type]
                : Colors.grey[300],
            child: Icon(
              eventTypeIcons[type],
              color: eventController.selectedEventType.value == type
                  ? Colors.white
                  : Colors.grey[600],
              size: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            type.tr,
            style: TextStyle(
              color: eventController.selectedEventType.value == type
                  ? eventTypeColors[type]
                  : Colors.grey[600],
              fontWeight: eventController.selectedEventType.value == type
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventStatusSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildEventStatusOption('PENDING'),
        _buildEventStatusOption('IN_PROGRESS'),
        _buildEventStatusOption('COMPLETED'),
      ],
    );
  }

  Widget _buildEventStatusOption(String status) {
    // Format the status text
    String formattedStatus = status
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');

    // Define a consistent size for all options
    const double optionSize = 100.0; // Adjust this value as needed

    return GestureDetector(
      onTap: () {
        setState(() {
          if (eventController.selectedEventStatus.contains(status)) {
            eventController.selectedEventStatus.remove(status);
          } else {
            eventController.selectedEventStatus.add(status);
          }
        });
      },
      child: SizedBox(
        width: optionSize,
        height: optionSize,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: eventController.selectedEventStatus.contains(status)
                  ? AppColors.mainBlueColor
                  : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                statusIcons[status] ?? Icons.help_outline,
                color: eventController.selectedEventStatus.contains(status)
                    ? AppColors.mainBlueColor
                    : Colors.grey,
                size: Dimensions.iconSize24,
              ),
              SizedBox(height: 4),
              Text(
                formattedStatus.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize:
                        Dimensions.font16 * 0.8), // Adjust font size if needed
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTimeDateOption('TODAY'),
            SizedBox(width: Dimensions.width10),
            _buildTimeDateOption('TOMORROW'),
            SizedBox(width: Dimensions.width10),
            _buildTimeDateOption('THIS_WEEK'),
          ],
        ),
        SizedBox(height: 10),
        _buildCalendarOption(),
      ],
    );
  }

  Widget _buildTimeDateOption(String timeDate) {
    bool isSelected = eventController.selectedTimeFilter.value == timeDate;
    String formattedtimeDate =
        timeDate.tr.replaceAll('_', ' ').split(' ').join(' ');
    return OutlinedButton(
      onPressed: () {
        setState(() {
          eventController.selectedTimeFilter.value = isSelected ? '' : timeDate;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected
              ? AppColors.mainBlueColor
              : Colors.grey.withOpacity(0.7),
          width: 1.5,
        ),
        backgroundColor:
            isSelected ? AppColors.mainBlueColor : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20 * 0.5),
        ),
      ),
      child: Text(
        formattedtimeDate,
        style: TextStyle(
          fontSize: Dimensions.font16 * 0.8,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildCalendarOption() {
    bool isCalendarSelected =
        eventController.selectedTimeFilter.value != null &&
            !['TODAY', 'TOMORROW', 'THIS_WEEK']
                .contains(eventController.selectedTimeFilter.value);

    return OutlinedButton(
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2010),
          lastDate: DateTime(2030),
        );
        if (pickedDate != null) {
          setState(() {
            eventController.selectedTimeFilter.value =
                pickedDate.toString().split(' ')[0]; // Only keep the date part
          });
        }
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isCalendarSelected ? AppColors.mainBlueColor : Colors.grey,
          width: 1.5,
        ),
        backgroundColor:
            isCalendarSelected ? AppColors.mainBlueColor : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20 * 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today,
              color:
                  isCalendarSelected ? Colors.white : AppColors.mainBlueColor),
          SizedBox(width: Dimensions.width10),
          Text(
            isCalendarSelected
                ? eventController.selectedTimeFilter.value!
                : 'Choose from calendar'.tr,
            style: TextStyle(
              fontSize: Dimensions.font16 * 0.8,
              color: isCalendarSelected ? Colors.white : Colors.grey[700],
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios,
              color:
                  isCalendarSelected ? Colors.white : AppColors.mainBlueColor,
              size: 16),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 4,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  eventController.selectedEventType.value = 'ALL';
                  eventController.selectedEventStatus.value = ['PENDING'];
                  eventController.selectedTimeFilter.value = 'THIS_WEEK';
                });
              },
              child: Text(
                'RESET'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                  side:
                      BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
                ),
              ),
            ),
          ),
          // Space between buttons
          SizedBox(
            width: Dimensions.width20,
          ),
          Expanded(
            flex: 6,
            child: ElevatedButton(
              onPressed: () {
                EventFilters filters = EventFilters(
                    status: eventController.selectedEventStatus.value,
                    eventType: eventController.selectedEventType.value,
                    timeFilter: eventController.selectedTimeFilter.value);

                widget.onApplyFilters(filters);
                Navigator.pop(context);
              },
              child: Text(
                'APPLY'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainBlueColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
