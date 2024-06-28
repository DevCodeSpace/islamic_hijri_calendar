Introducing our Islamic Hijri Calendar widget, offering a comprehensive date display with both Arabic and English numerals. Easily view Hijri month names alongside the year and navigate through months effortlessly.

<img src="https://raw.githubusercontent.com/DevCodeSpace/islamic_hijri_calendar/main/assets/banner1.png" align="center" height="350" width="1500"/>

## Features

* Shows both english day & arabic day.
* Shows the Hijri month names along with the year.
* set custom font families manually & google font as well.
* Support for both light and dark modes for better visibility and user preference.
* Users can customize the colors to match their preferences or app theme.
* Users can easily change the month and year to navigate through the calendar.

## Getting started

Add dependency to your `pubspec.yaml` file & run Pub get

```yaml
dependencies:
  islamic_hijri_calendar: ^0.0.1
```
And import package into your class file

```dart
import 'package:islamic_hijri_calendar/islamic_hijri_calendar.dart';
```

## Usage

```dart
IslamicHijriCalendar(
   highlightBorder : Theme.of(context).colorScheme.primary, // Set selected date border color
   defaultBorder : Theme.of(context).colorScheme.onBackground.withOpacity(.1), // Set default date border color
   highlightTextColor : Theme.of(context).colorScheme.background, // Set today date text color            
   defaultTextColor : Theme.of(context).colorScheme.onBackground, //Set others dates text color            
   defaultBackColor : Theme.of(context).colorScheme.background, // Set default date background color            
   adjustmentValue: 0, // Set islamic hijri calendar adjustment value which is set  by user side
   isGoogleFont: true, // Set it true if you want to use google fonts else false            
   fontFamilyName: "Lato", // Set your custom font family name or google font name
   getSelectedEnglishDate: (selectedDate){ // returns the date selected by user
     print("English Date : $selectedDate");
   },            
   getSelectedHijriDate: (selectedDate){ // returns the date selected by user in Hijri format
     print("Hijri Date : $selectedDate");
   },            
   isDisablePreviousNextMonthDates: true, // Set dates which are not included in current month should show disabled or enabled
),
```

## Properties

| Property                        | Types               | Description                                                                       |
|---------------------------------|---------------------|-----------------------------------------------------------------------------------|
| highlightBorder                 | Color?              | Set selected date border color                                                    |
| defaultBorder                   | Color?              | Set default date border color                                                     |
| highlightTextColor              | Color?              | Set today date text color                                                         |
| defaultTextColor                | Color?              | Set others dates text color                                                       |
| defaultBackColor                | Color?              | Set default date background color                                                 |
| adjustmentValue                 | int                 | Set hijri calendar adjustment value which is set  by user side                    |
| isGoogleFont                    | bool?               | Set it true if you want to use google fonts else false                            |
| fontFamilyName                  | String?             | Set your custom font family name or google font name                              |
| getSelectedEnglishDate          | return selectedDate | returns the date selected by user                                                                          |
| getSelectedHijriDate            | return selectedDate | returns the date selected by user in Hijri format                                            |
| isDisablePreviousNextMonthDates | bool?               | Set dates which are not included in current month should show disabled or enabled |
