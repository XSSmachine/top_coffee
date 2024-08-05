import 'package:flutter/material.dart';

import 'icon_and_text_widget.dart';

class EventTypeChip extends StatefulWidget {
  final String label;
  final Color color;
  final IconData icon;
  final String selectedEventType;
  final Function(String) onEventTypeChanged;

  const EventTypeChip({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    required this.selectedEventType,
    required this.onEventTypeChanged,
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
        widget.onEventTypeChanged(selected ? widget.label : "MIX");
      },
      selected: widget.selectedEventType == widget.label,
    );
  }
}
