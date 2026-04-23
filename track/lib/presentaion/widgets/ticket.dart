import 'package:flutter/material.dart';
import 'package:track/core/theme/colors.dart';

class TicketsBox extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const TicketsBox({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = const ["Bus Ticket", "Flight Ticket", "Car"];

    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: ColorManager.prymaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (i) {
          final isSelected = selectedIndex == i;

          return InkWell(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.grey.shade200 : Colors.white,
                border: Border(
                  top: i == 0
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 3,
                    height: 18,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    items[i],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Modal Bottom Sheet (ستايل حديث)
Future<int?> showTicketsSheet(
  BuildContext context, {
  required int initialSelected,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      int tempSelected = initialSelected;

      return StatefulBuilder(
        builder: (context, setLocalState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // drag handle
                Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Choose Ticket",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Ticket type",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Center(
                  child: TicketsBox(
                    selectedIndex: tempSelected,
                    onChanged: (i) => setLocalState(() => tempSelected = i),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, tempSelected),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    },
  );
}
