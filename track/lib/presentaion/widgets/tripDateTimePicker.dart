import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripDateTimeResult {
  final DateTime start;
  final DateTime end;

  const TripDateTimeResult({required this.start, required this.end});
}

/// يفتح BottomSheet فيه Wheel Pickers لبداية/نهاية الرحلة (بدون Calendar)
Future<TripDateTimeResult?> showTripWheelPicker(
  BuildContext context, {
  DateTime? currentStart,
  DateTime? currentEnd,
}) {
  final now = DateTime.now();

  DateTime tempStart = currentStart ?? now;
  DateTime tempEnd = currentEnd ?? now.add(const Duration(days: 1));

  return showModalBottomSheet<TripDateTimeResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setLocalState) {
          String two(int n) => n.toString().padLeft(2, '0');

          String fmt(DateTime d) =>
              "${two(d.day)}/${two(d.month)}/${d.year}  ${two(d.hour)}:${two(d.minute)}";

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // handle
                Container(
                  width: 42,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Trip date & time",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // عرض مختصر للقيم
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Start: ${fmt(tempStart)}",
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text("End:   ${fmt(tempEnd)}",
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Start picker
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 170,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: tempStart,
                    minimumDate: now.subtract(const Duration(days: 1)),
                    maximumDate: DateTime(now.year + 2, 12, 31),
                    use24hFormat: true,
                    onDateTimeChanged: (d) {
                      setLocalState(() {
                        tempStart = d;
                        // خلي النهاية دائمًا بعد البداية على الأقل بدقيقة
                        if (!tempEnd.isAfter(tempStart)) {
                          tempEnd = tempStart.add(const Duration(minutes: 1));
                        }
                      });
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // End picker
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "End",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 170,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: tempEnd,
                    minimumDate: tempStart.add(const Duration(minutes: 1)),
                    maximumDate: DateTime(now.year + 2, 12, 31),
                    use24hFormat: true,
                    onDateTimeChanged: (d) {
                      setLocalState(() => tempEnd = d);
                    },
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        TripDateTimeResult(start: tempStart, end: tempEnd),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
