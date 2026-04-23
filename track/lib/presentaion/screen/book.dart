import 'package:flutter/material.dart';
import 'package:track/core/const/txt.dart';
import 'package:track/presentaion/widgets/app_bottom_bar.dart';
import 'package:track/presentaion/widgets/button_style.dart';
import 'package:track/presentaion/widgets/smartButton.dart';
import 'package:track/presentaion/widgets/text_form_field_widget.dart';
import 'package:track/presentaion/widgets/ticket.dart';
import 'package:track/presentaion/widgets/ticketsList.dart';
import 'package:track/presentaion/widgets/tripDateTimePicker.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final numberController = TextEditingController();
  final durationController = TextEditingController();

  bool forSmartNavi = false;
  int selectedTicket = 0;
  bool isLoading = false;

  DateTime? startDateTime;
  DateTime? endDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 80),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormFieldWidget(
                  hintText: 'From',
                  controller: fromController,
                  hight: 40,
                  width: 188,
                ),
                TextFormFieldWidget(
                  hintText: 'To',
                  controller: toController,
                  hight: 40,
                  width: 188,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  children: [
                    Text('Tickts'),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () async {
                        final res = await showTicketsSheet(
                          context,
                          initialSelected:
                              selectedTicket, // المتغير عندك بالـState
                        );

                        if (res != null) {
                          setState(() => selectedTicket = res);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTicket == 0
                                  ? "Bus Ticket"
                                  : selectedTicket == 1
                                  ? "Flight Ticket"
                                  : "Car",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Text('number'),
                    SizedBox(height: 5),
                    TextFormFieldWidget(
                      controller: numberController,
                      hight: 50,
                      width: 80,
                      
                      
                      
                    ),
                  ],
                ),
                Center(
                  child: InkWell(
                    child: MyButtonStyle(
                      buttonHight: 50,
                      buttonWidth: 170,
                      raduis: 30,
                      buttonText: ' company',
                      isLoading: isLoading,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            InkWell(
              child: MyButtonStyle(
                buttonHight: 50,
                buttonWidth: 170,
                buttonText: ' Contact Guide',
                raduis: 30,
                isLoading: isLoading,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final res = await showTripWheelPicker(
                  context,
                  currentStart: startDateTime,
                  currentEnd: endDateTime,
                );

                if (res != null) {
                  setState(() {
                    startDateTime = res.start;
                    endDateTime = res.end;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select trip date & time",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.date_range),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                       "Trip Duration",
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Bold',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  child: MyButtonStyle(
                    buttonHight: 50,
                    buttonWidth: 170,
                    raduis: 30,
                    buttonText: (startDateTime==null || endDateTime==null) ?  "Select dates":"${endDateTime!.difference(startDateTime!).inDays + 1} days",
                    isLoading: isLoading,
                  ),
                ),
                
              ],
            ),
            SizedBox(height: 20),
             InkWell(
               child: MyButtonStyle(
                 buttonHight: 50,
                 buttonWidth: 170,
                 raduis: 30,
                 buttonText: 'Done',
                 isLoading: isLoading,
               ),
             ),
          ],
        ),

      ),
                    bottomNavigationBar:  AppBottomBar(currentIndex: 1),

    );
  }
}
