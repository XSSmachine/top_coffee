import 'package:flutter/material.dart';

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

class _EventTypeChipState extends State<EventTypeChip> {
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
      ),
      backgroundColor: widget.color,
      selectedColor: widget.color,
      onSelected: (bool selected) {
        widget.onEventTypeChanged(selected
            ? widget.label
            : widget.firstSelected == null
                ? "MIX"
                : widget.firstSelected!);
      },
      selected: widget.selectedEventType == widget.label,
    );
  }
}
