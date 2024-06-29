import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'hijri_calendar_config.dart';
import 'hijri_date.dart';
import 'hijri_view_model.dart';

class IslamicHijriCalendar extends StatefulWidget {

  ///set selected date border color
  final Color highlightBorder;

  ///set default date border color
  final Color defaultBorder;

  ///set today date text color
  final Color highlightTextColor;

  ///set others dates text color
  final Color defaultTextColor;

  ///set default date background color
  final Color defaultBackColor;

  ///set hijri calendar adjustment value which is set  by user side
  final int adjustmentValue;

  ///set it true if you want to use google fonts else false
  final bool? isGoogleFont;

  ///set your custom font family name or google font name
  final String? fontFamilyName;

  ///when user taps on date get selected date
  final Function(DateTime selectedDate)? getSelectedEnglishDate;

  ///when user taps on date get selected hijri date
  final Function(HijriDate selectedDate)? getSelectedHijriDate;

  ///set dates which are not included in current month should show disabled or enabled
  final bool? isDisablePreviousNextMonthDates;

  const IslamicHijriCalendar({
    super.key,
    this.highlightBorder = Colors.blue,
    this.defaultBorder = const Color(0xfff2f2f2),
    this.highlightTextColor = Colors.white,
    this.defaultTextColor = Colors.black,
    this.defaultBackColor = Colors.white,
    this.adjustmentValue = 0,
    this.getSelectedHijriDate,
    this.getSelectedEnglishDate,
    this.fontFamilyName = "",
    this.isGoogleFont = false,
    this.isDisablePreviousNextMonthDates = true,
  });

  @override
  State<IslamicHijriCalendar> createState() => _HijriCalendarWidgetsState();
}

class _HijriCalendarWidgetsState extends State<IslamicHijriCalendar> {

  HijriViewModel viewmodel = HijriViewModel();
  List<DateTime> days = [];

  ///update calendar view when directly value change form user side without set state
  @override
  void didUpdateWidget(IslamicHijriCalendar oldWidget) {
    if (oldWidget.adjustmentValue != widget.adjustmentValue) {
      viewmodel.adjustmentValue = widget.adjustmentValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  String direction = 'None';

  ///on pan update event check direction
  _onPanUpdate(DragUpdateDetails details) {

    if (details.delta.dx > 0) {
      direction = 'Right';
    } else if (details.delta.dx < 0) {
      direction = 'Left';
    } else if (details.delta.dy > 0) {
      direction = 'Down';
    } else if (details.delta.dy < 0) {
      direction = 'Up';
    }
  }

  ///on pan gesture update current month
  _onPanEnd() {
    switch (direction){
      case "None":break;
      case "Right":funcGetMonth(isPrevious: true);break;
      case "Left":funcGetMonth(isPrevious: false);break;
      case "Down":funcGetMonth(isPrevious: true);break;
      case "Up":funcGetMonth(isPrevious: false);break;
    }
  }

  ///click events of previous & next button
  funcGetMonth({required bool isPrevious}){
    isPrevious ? viewmodel.getPreviousMonth() : viewmodel.getNextMonth();
    setState(() {});
  }

  ///get total days in month with previous & next month days in first & last week
  List<DateTime> _getDaysInMonth(DateTime date) {
    days = [];

    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    int firstWeekday = firstDayOfMonth.weekday;
    int lastWeekday = lastDayOfMonth.weekday;

    // Add days from previous month
    for (int i = firstWeekday - 1; i > 0; i--) {
      days.add(firstDayOfMonth.subtract(Duration(days: i)));
    }

    // Add days of current month
    for (int i = 0; i < lastDayOfMonth.day; i++) {
      days.add(firstDayOfMonth.add(Duration(days: i)));
    }

    // Add days from next month
    for (int i = 1; i <= 7 - lastWeekday; i++) {
      days.add(lastDayOfMonth.add(Duration(days: i)));
    }
    return days;
  }

  ///set calendar grid view
  Widget funcCalendarDaysView({required TextStyle textStyle,required double rowHeight, required double fontSize}){
    return GestureDetector(
      onPanUpdate: (details) => _onPanUpdate(details),
      onPanEnd: (details) => _onPanEnd(),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisExtent: rowHeight,
        ),
        itemCount: days.length,
        itemBuilder: (BuildContext context, int index) {
          ///single day block
          return viewmodel.getDate(
              fontSize: fontSize,
              defaultTextColor: widget.defaultTextColor,
              highlightTextColor: widget.highlightTextColor,
              day: days[index],
              highlightBorder: widget.highlightBorder,
              defaultBorder: widget.defaultBorder,
              backgroundColor: widget.defaultBackColor,
              deActiveDateBorderColor: widget.defaultBorder,
              style: textStyle,
              onSelectedEnglishDate: (selectedDate) {
                if (widget.getSelectedEnglishDate != null) {
                  widget.getSelectedEnglishDate!(selectedDate);
                }
                setState(() {});
              },
              onSelectedHijriDate: (selectedDate) {
                if (widget.getSelectedHijriDate != null) {
                  widget.getSelectedHijriDate!(selectedDate);
                }
              },
              isDisablePreviousNextMonthDates: widget.isDisablePreviousNextMonthDates!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    ///get total days in current month with previous(first week) & next months(last week) dates
    days = _getDaysInMonth(viewmodel.currentDisplayMonthYear);
    viewmodel.adjustmentValue = widget.adjustmentValue;

    TextStyle textStyle = widget.isGoogleFont! ? GoogleFonts.getFont(widget.fontFamilyName!) :
    widget.fontFamilyName!.isEmpty ? const TextStyle() : TextStyle(fontFamily: widget.fontFamilyName!);

    return LayoutBuilder(builder: (context, constraints) {

      double parentWidth = constraints.maxWidth;
      double parentHeight = constraints.maxHeight;

      ///minimum height of particular day box
      double minRowHeight = 70;
      double fontSize = 16;

      if (parentWidth > 600) {
        // Large screen (e.g., tablets), use larger font size
        fontSize = 18;
      } else if (parentWidth > 400) {
        // Medium screen (e.g., larger phones), use medium font size
        fontSize = 16;
      } else {
        // Smaller screen (e.g., small phones), use smaller font size
        fontSize = 16;
      }

      return Column(
        children: [
          // previous month button, month name & year, next month button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              ///navigate to previous month button
              GestureDetector(
                onTap: () => funcGetMonth(isPrevious: true),
                child: Container(
                  width: parentWidth / 7,
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  alignment: Alignment.center,
                  child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: fontSize,
                      color: widget.defaultTextColor),
                ),
              ),

              ///rest of the space set  english month name & year
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Theme(
                            data: ThemeData(
                              useMaterial3: false,
                              colorScheme: Theme.of(context).brightness == Brightness.dark
                                  ? ColorScheme.dark(
                                primary: widget.highlightBorder,
                                onPrimary: widget.highlightTextColor,
                                onSurface: widget.defaultTextColor,
                              )
                                  : ColorScheme.light(
                                primary: widget.highlightBorder,
                                onPrimary: widget.highlightTextColor,
                                onSurface: widget.defaultTextColor,
                              ),
                            ),
                            child: DatePickerDialog(
                              initialDate: viewmodel.currentDisplayMonthYear,
                              firstDate: DateTime(1900, 1, 1),
                              lastDate: DateTime(2050, 12, 31),
                            ),
                          );
                        },
                      );
                      if (pickedDate != null && pickedDate != viewmodel.todayDate) {
                        setState(() {
                          viewmodel.selectedDate = pickedDate;
                          viewmodel.currentDisplayMonthYear = pickedDate;
                        });
                      }
                    },
                    child: Center(
                      child: Text(
                        DateFormat('MMM yyyy').format(viewmodel.currentDisplayMonthYear),
                        style: textStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: fontSize,
                            color: widget.defaultTextColor),
                      ),
                    ),
                  ),
                ),
              ),

              ///navigate to next month button
              GestureDetector(
                onTap: () => funcGetMonth(isPrevious: false),
                child: Container(
                  width: parentWidth / 7,
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  alignment: Alignment.center,
                  child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: fontSize,
                      color: widget.defaultTextColor),
                ),
              ),
            ],
          ),

          ///show hijri calendar current month name & year
          Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.highlightBorder,
            ),
            child: Text(
              "${viewmodel.getHijriMonthYear()} - ${HijriCalendarConfig.fromDate(viewmodel.currentDisplayMonthYear).hYear}",
              textAlign: TextAlign.center,
              style: textStyle.copyWith(
                  fontSize: fontSize,
                  color: widget.highlightTextColor),
            ),
          ),

          ///show week name Mon to Sun in a row
          Container(
            color: widget.defaultBorder,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: List.generate(viewmodel.headerOfDay.length, (index) {
                  return Expanded(
                    child: Center(
                      child: Text(
                          viewmodel.headerOfDay[index],
                          style: textStyle.copyWith(
                              fontSize: fontSize-2,
                              color: widget.defaultTextColor)),
                    ),
                  );
                }),
              ),
            ),
          ),

          ///in a rest of the space show calendar
          parentHeight == double.infinity ?

          funcCalendarDaysView(textStyle: textStyle,rowHeight: minRowHeight,fontSize: fontSize)
              :
          Expanded(
              child:
              LayoutBuilder(
                builder: (context, constraints) {
                  double screenHeight = constraints.maxHeight;
                  double calculatedRowHeight = screenHeight / (days.length/7);
                  double rowHeight = calculatedRowHeight < minRowHeight ? minRowHeight : calculatedRowHeight;

                  return  funcCalendarDaysView(textStyle: textStyle,rowHeight: rowHeight,fontSize: fontSize);
                },)

          ),
        ],
      );
    });
  }
}