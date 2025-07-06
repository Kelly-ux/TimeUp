import 'package:flutter/material.dart';

class SegmentedButton extends StatefulWidget {
  const SegmentedButton({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onSegmentSelected,
  });

  final List<String> segments;
  final int selectedIndex;
  final ValueChanged<int> onSegmentSelected;

  @override
  SegmentedButtonState createState() => SegmentedButtonState();
}

class SegmentedButtonState extends State<SegmentedButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.segments.length, (index) {
        final isSelected = index == widget.selectedIndex;
        return Expanded(
          child: InkWell(
            onTap: () {
              widget.onSegmentSelected(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[200],
                borderRadius: BorderRadius.horizontal(
                  left: index == 0 ? Radius.circular(8.0) : Radius.zero,
                  right: index == widget.segments.length - 1
                      ? Radius.circular(8.0)
                      : Radius.zero,
                ),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
              ),
              child: Center(
                child: Text(
                  widget.segments[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}