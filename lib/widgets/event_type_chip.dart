import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/string_resources.dart';
import 'icon_and_text_widget.dart';

class EventTypeChip extends StatefulWidget {
  final String label;
  final Color color;
  final IconData icon;
  final String selectedEventType;
  final Function(String) onEventTypeChanged;
  final String? firstSelected;

  const EventTypeChip({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    required this.selectedEventType,
    required this.onEventTypeChanged,
    this.firstSelected,
  });

  @override
  _EventTypeChipState createState() => _EventTypeChipState();
}

final Map<String, String> labelTranslations = {
  'SVE': 'ALL',
  'KAVA': 'COFFEE',
  'HRANA': 'FOOD',
  'PIĆE': 'BEVERAGE',
};

bool isSelected(String label, String selectedType) {
  final String englishLabel = labelTranslations[label] ?? label;
  return selectedType.toLowerCase() == englishLabel.toLowerCase();
}

class _EventTypeChipState extends State<EventTypeChip> {
  String getEnglishLabel(String label) {
    return labelTranslations[label] ?? label;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: widget.color),
      ),
      label: IconAndTextWidget(
        icon: widget.icon,
        text: widget.label,
        iconColor: Colors.white,
        size: IconAndTextSize.normal,
      ),
      backgroundColor: widget.color,
      selectedColor: widget.color,
      onSelected: (bool selected) {
        String englishLabel = selected
            ? getEnglishLabel(widget.label)
            : widget.firstSelected == null
                ? getEnglishLabel(
                    'SVE') // Use 'SVE' instead of AppStrings.allFilter.tr
                : getEnglishLabel(widget.firstSelected!);
        widget.onEventTypeChanged(englishLabel);
      },
      selected: isSelected(widget.label, widget.selectedEventType),
    );
  }
}
