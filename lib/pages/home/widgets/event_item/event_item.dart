import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../models/event_model.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/dimensions.dart';
import '../../../../utils/string_resources.dart';
import '../../../../widgets/icon_and_text_widget.dart';

class EventListItem extends StatelessWidget {
  final EventModel event;
  final String eventStatus;
  final Function(String) onTap;

  const EventListItem({
    Key? key,
    required this.event,
    required this.eventStatus,
    required this.onTap,
  }) : super(key: key);

  String _getImagePath(String eventType) {
    switch (eventType) {
      case "FOOD":
        return 'assets/image/burek.png';
      case "COFFEE":
        return 'assets/image/turska.png';
      case "BEVERAGE":
        return 'assets/image/pice.png';
      default:
        return 'assets/image/placeholder.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(event.eventId ?? ""),
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: Dimensions.height10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SizedBox(
          height: Dimensions.height20 * 6, // Adjust this value as needed
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.width10 / 2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      child: Image.asset(
                        _getImagePath(event.eventType ?? "FOOD"),
                        width: Dimensions.width20 * 5,
                        height: Dimensions.height20 * 6,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width15 / 3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.height10),
                        Text(
                          _formatDate(event.createdAt),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Dimensions.font16 * 0.9,
                          ),
                        ),
                        SizedBox(height: Dimensions.height10 / 4),
                        Text(
                          event.title ?? 'No Title',
                          style: TextStyle(
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimensions.height10 / 4),
                        Flexible(
                          child: Text(
                            truncateToThreeWords(
                                event.description ?? "No description"),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: Dimensions.font16 * 0.9,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: Dimensions.height10 / 2),
                        Row(
                          children: [
                            Icon(Icons.person_rounded),
                            SizedBox(
                              width: Dimensions.width10 / 2,
                            ),
                            Text(
                              '${event.userProfileFirstName} ${event.userProfileLastName}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: Dimensions.font16 * 0.8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: Dimensions.width10,
                child: _buildFilterChip(event.eventType),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String? foodType) {
    IconData icon;
    String label;
    Color backgroundColor;

    switch (foodType?.toUpperCase()) {
      case "COFFEE":
        icon = Icons.coffee;
        label = AppStrings.coffeeFilter.tr;
        backgroundColor = AppColors.orangeChipColor;
        break;
      case "FOOD":
        icon = Icons.restaurant;
        label = AppStrings.foodFilter.tr;
        backgroundColor = AppColors.greenChipColor;
        break;
      default:
        icon = Icons.liquor;
        label = AppStrings.beverageFilter.tr;
        backgroundColor = AppColors.blueChipColor;
    }

    return FilterChip(
      label: IconAndTextWidget(
        icon: icon,
        text: label,
        iconColor: Colors.white,
        size: IconAndTextSize.small,
      ),
      backgroundColor: backgroundColor,
      onSelected: (bool value) {},
      selected: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: backgroundColor),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'No date';

    final date = DateTime.tryParse(dateString);
    if (date == null) return 'Invalid date';

    final dateFormatter = DateFormat('dd.MM.yyyy');
    final timeFormatter = DateFormat('HH:mm');

    final formattedDate = dateFormatter.format(date);
    final formattedTime = timeFormatter.format(date);

    return '$formattedDate - $formattedTime';
  }

  String truncateToThreeWords(String text) {
    List<String> words = text.split(' ');
    if (words.length <= 3) {
      return text;
    } else {
      return '${words.take(3).join(' ')}...';
    }
  }
}
