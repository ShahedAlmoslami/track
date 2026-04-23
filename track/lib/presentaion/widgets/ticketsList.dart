import 'package:flutter/material.dart';

enum TicketType { bus, flight, car }

class ModernTicketsList extends StatefulWidget {
  const ModernTicketsList({super.key});

  @override
  State<ModernTicketsList> createState() => _ModernTicketsListState();
}

class _ModernTicketsListState extends State<ModernTicketsList> {
  TicketType selected = TicketType.bus;

  final items = const [
    (TicketType.bus, "Bus Ticket", Icons.directions_bus_rounded),
    (TicketType.flight, "Flight Ticket", Icons.flight_rounded),
    (TicketType.car, "Car", Icons.directions_car_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (i) {
          final type = items[i].$1;
          final title = items[i].$2;
          final icon = items[i].$3;
          final isSelected = selected == type;

          return Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 6),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => selected = type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.grey.shade100 : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? Colors.grey.shade300 : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      // indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeInOut,
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.black : Colors.transparent,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Icon(
                        icon,
                        size: 18,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.black : Colors.grey.shade700,
                          ),
                          child: Text(title),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
