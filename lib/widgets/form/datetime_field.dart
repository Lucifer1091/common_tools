// import 'package:intl/intl.dart';
//
// import 'package:flutter/material.dart';
//
// enum DateTimeType { date, time, dateTime, month, year, monthYear }
//
// typedef OnDateTimeSelect = void Function(DateTime? dateTime, TimeOfDay? time);
//
// class CustomDateTimeField extends StatelessWidget {
//   final DateFormat? format;
//   final TextEditingController? controller;
//
//   final FocusNode? focusNode;
//   final bool? autofocus;
//
//   final String? labelText;
//   final FloatingLabelBehavior floatingLabelBehavior;
//   final Color? labelColor;
//   final TextStyle? labelStyle;
//
//   final bool? readOnly;
//   final bool enabled;
//   final bool isRequired;
//   final String requiredLabelCharacter;
//   final Color? requiredLabelColor;
//
//   final BoxConstraints? prefixIconConstraints;
//   final Widget? prefixWidget;
//   final IconData? prefixIcon;
//   final Color? prefixIconColor;
//   final IconData? suffixIcon;
//   final Color? suffixIconColor;
//
//   final void Function(DateTime?)? onChanged;
//   final void Function(DateTime?)? onSave;
//   final void Function(DateTime?)? onFieldSubmit;
//   final VoidCallback? onEditingComplete;
//
//   final String? Function(DateTime?)? validator;
//
//   final TextInputAction? textInputAction;
//
//   final Color? textColor;
//   final TextStyle? textStyle;
//
//   final Color? fillColor;
//   final Color? cursorColor;
//   final Color? errorColor;
//
//   final double height;
//   final double? width;
//   final double verticalPadding;
//
//   final Color? enableBorderColor;
//   final Color? focusBorderColor;
//   final Color? errorBorderColor;
//   final double? borderRadius;
//
//   final DateTimeType dateTimeType;
//   final OnDateTimeSelect? onDateTimeSelect;
//
//   final DateTime? initialDate;
//   final DateTime? firstDate;
//   final DateTime? lastDate;
//   final DatePickerMode? initialDatePickerMode;
//   final MonthYearPickerMode? initialMonthPickerMode;
//
//   final TimeOfDay? initialTime;
//   final bool showClearButton;
//
//   const CustomDateTimeField({
//     super.key,
//     this.onDateTimeSelect,
//     this.format,
//     this.dateTimeType = DateTimeType.date,
//     this.isRequired = false,
//     this.requiredLabelColor,
//     this.requiredLabelCharacter = '*',
//     this.labelText,
//     this.floatingLabelBehavior = FloatingLabelBehavior.auto,
//     this.labelColor,
//     this.labelStyle,
//     this.prefixIconConstraints,
//     this.prefixWidget,
//     this.prefixIcon,
//     this.prefixIconColor,
//     this.suffixIcon,
//     this.suffixIconColor,
//     this.showClearButton = false,
//     this.onChanged,
//     this.validator,
//     this.onSave,
//     this.textInputAction,
//     this.onEditingComplete,
//     this.controller,
//     this.onFieldSubmit,
//     this.readOnly,
//     this.enabled = true,
//     this.focusNode,
//     this.fillColor,
//     this.cursorColor,
//     this.errorColor,
//     this.autofocus,
//     this.textColor,
//     this.textStyle,
//     this.verticalPadding = 6,
//     this.width,
//     this.enableBorderColor,
//     this.focusBorderColor,
//     this.errorBorderColor,
//     this.borderRadius,
//     this.height = 8,
//     this.initialDate,
//     this.firstDate,
//     this.lastDate,
//     this.initialDatePickerMode,
//     this.initialMonthPickerMode,
//     this.initialTime,
//   })  : assert(
//           labelStyle == null || labelColor == null,
//           'Cannot provide both a labelStyle and a labelColor\n'
//           'To provide custom, use "labelStyle: TextStyle()".',
//         ),
//         assert(
//           textStyle == null || textColor == null,
//           'Cannot provide both a textStyle and a textColor\n'
//           'To provide custom, use "textStyle: TextStyle()".',
//         ),
//         assert(
//           prefixWidget == null || prefixIcon == null,
//           'Cannot provide both a prefixWidget and a prefixIconData\n'
//           'To provide custom, use "prefixWidget".',
//         ),
//         assert(
//           prefixWidget == null || prefixIconColor == null,
//           'Cannot provide both a prefixWidget and a prefixIconColor\n'
//           'To provide custom, use "prefixWidget".',
//         );
//
//   static Future<TimeOfDay?> getTime(
//     BuildContext context, {
//     TimeOfDay? initialTime,
//   }) async {
//     return await showTimePicker(
//       context: context,
//       initialTime: initialTime ?? TimeOfDay.now(),
//       initialEntryMode: TimePickerEntryMode.dial,
//       builder: getTheme,
//     );
//   }
//
//   static Future<DateTime?> getDate(
//     BuildContext context, {
//     DateTime? initialDate,
//     DateTime? firstDate,
//     DateTime? lastDate,
//     DatePickerMode? initialDatePickerMode,
//   }) async {
//     return await showDatePicker(
//       context: context,
//       initialDate: initialDate ?? DateTime.now(),
//       firstDate: firstDate ?? DateTime(1990),
//       lastDate: lastDate ?? DateTime.now(),
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//       initialDatePickerMode: initialDatePickerMode ?? DatePickerMode.day,
//       builder: getTheme,
//     );
//   }
//
//   static Future<DateTimeRange?> getDateRange(
//     BuildContext context, {
//     DateTimeRange? initialDateRange,
//     DateTime? firstDate,
//     DateTime? lastDate,
//   }) async {
//     return await showDateRangePicker(
//       context: context,
//       initialDateRange: initialDateRange,
//       firstDate: firstDate ?? DateTime(1990),
//       lastDate: lastDate ?? DateTime(2050),
//       builder: getTheme,
//       initialEntryMode: DatePickerEntryMode.calendarOnly,
//     );
//   }
//
//   static Future<DateTime?> getMonthYear(
//     BuildContext context, {
//     DateTime? initialDate,
//     DateTime? firstDate,
//     DateTime? lastDate,
//     MonthYearPickerMode? initialMonthPickerMode,
//   }) async {
//     return await showMonthYearPicker(
//       context: context,
//       initialDate: initialDate ?? DateTime.now(),
//       firstDate: firstDate ?? DateTime(1990),
//       lastDate: lastDate ?? DateTime.now(),
//       initialMonthYearPickerMode:
//           initialMonthPickerMode ?? MonthYearPickerMode.month,
//       builder: getTheme,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width ?? double.infinity,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: verticalPadding),
//         child: DateTimeField(
//           enabled: enabled,
//           format: format ?? getFormat,
//           controller: controller,
//           initialValue: initialDate,
//           onShowPicker: (context, __) async {
//             switch (dateTimeType) {
//               // TODO : Break Month and Year Pickers in Separate Cases
//               case DateTimeType.month:
//               case DateTimeType.year:
//               case DateTimeType.monthYear:
//                 final date = await getMonthYear(
//                   context,
//                   initialDate: initialDate,
//                   firstDate: firstDate,
//                   lastDate: lastDate,
//                   initialMonthPickerMode: initialMonthPickerMode,
//                 );
//                 onDateTimeSelect?.call(date, null);
//                 return date;
//
//               case DateTimeType.date:
//                 final date = await getDate(
//                   context,
//                   initialDate: initialDate,
//                   firstDate: firstDate,
//                   lastDate: lastDate,
//                   initialDatePickerMode: initialDatePickerMode,
//                 );
//                 onDateTimeSelect?.call(date, null);
//                 return date;
//
//               case DateTimeType.time:
//                 final time = await getTime(context, initialTime: initialTime);
//                 onDateTimeSelect?.call(null, time);
//                 return DateTimeField.convert(time);
//
//               case DateTimeType.dateTime:
//               default:
//                 TimeOfDay? time;
//
//                 final date = await getDate(
//                   context,
//                   initialDate: initialDate,
//                   firstDate: firstDate,
//                   lastDate: lastDate,
//                   initialDatePickerMode: initialDatePickerMode,
//                 ).then((date) async {
//                   if (date != null) {
//                     var initialTime = TimeOfDay(
//                       hour: firstDate?.hour ?? 0,
//                       minute: firstDate?.minute ?? 0,
//                     );
//                     time = await getTime(context, initialTime: initialTime);
//                   }
//                   return date;
//                 });
//                 onDateTimeSelect?.call(DateTimeField.combine(date, time), time);
//                 return DateTimeField.combine(date, time);
//             }
//           },
//           cursorColor: cursorColor ?? AppColors.blueShade1,
//           cursorRadius: const Radius.circular(32),
//           cursorWidth: Sizes.WIDTH_2,
//           decoration: buildInputDecoration(context),
//           maxLengthEnforcement: MaxLengthEnforcement.enforced,
//           autofocus: autofocus ?? false,
//           focusNode: focusNode,
//           readOnly: readOnly ?? true,
//           onFieldSubmitted: onFieldSubmit,
//           maxLines: 1,
//           scrollPadding: const EdgeInsets.all(8),
//           onEditingComplete: onEditingComplete,
//           textInputAction: textInputAction,
//           autovalidateMode: AutovalidateMode.disabled,
//           onSaved: onSave,
//           validator: (value) {
//             if (isRequired) {
//               if (controller?.text.trim().isEmpty ?? true) {
//                 return '${(labelText)} is required.';
//               }
//             }
//
//             if (validator != null) return validator!(value);
//
//             return null;
//           },
//           onChanged: onChanged,
//           obscureText: false,
//           style: textStyle ??
//               context.textTheme.titleMedium!.copyWith(
//                 color: textColor ?? Colors.black,
//                 fontWeight: FontWeight.w400,
//               ),
//           resetIcon: showClearButton
//               ? Icon(
//                   suffixIcon ?? EneftyIcons.close_circle_bold,
//                   size: 20,
//                   color: suffixIconColor ?? const Color(0xff8e8e93),
//                 )
//               : null,
//         ),
//       ),
//     );
//   }
//
//   InputDecoration buildInputDecoration(BuildContext context) {
//     return InputDecoration(
//       contentPadding: EdgeInsets.only(
//         left: 8,
//         right: 2,
//         top: height,
//         bottom: height,
//       ),
//       floatingLabelBehavior: floatingLabelBehavior,
//       floatingLabelAlignment: FloatingLabelAlignment.start,
//       label: RichText(
//         overflow: TextOverflow.ellipsis,
//         text: TextSpan(
//           style: labelStyle ??
//               context.bodyLarge.copyWith(
//                 color: labelColor ?? Colors.black,
//                 fontWeight: FontWeight.w400,
//               ),
//           children: [
//             TextSpan(text: labelText),
//             if (isRequired) ...[
//               const WidgetSpan(child: SpaceW4()),
//               TextSpan(
//                 text: requiredLabelCharacter,
//                 style: context.textTheme.titleLarge!.copyWith(
//                   color: requiredLabelColor ?? const Color(0xFFF1291A),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//       prefixIconConstraints: prefixIconConstraints,
//       prefixIcon: prefixWidget ??
//           (prefixIcon != null
//               ? Icon(
//                   prefixIcon,
//                   size: 22,
//                   color: prefixIconColor ?? Colors.grey,
//                 )
//               : null),
//       suffixIcon: showClearButton
//           ? null
//           : Icon(
//               suffixIcon,
//               size: 22,
//               color: suffixIconColor ?? Colors.grey,
//             ),
//       // suffixIcon: suffixIcon != null
//       //     ? GestureDetector(
//       //         onTap: onSuffixTap,
//       //         child: Icon(
//       //           suffixIcon,
//       //           size: 20,
//       //           color: suffixIconColor ?? Colors.grey,
//       //         ),
//       //       ).mouseRegion
//       //     : suffixWidget,
//       enabledBorder: borderRadius != null
//           ? OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(borderRadius ?? 6),
//               borderSide: BorderSide(
//                 color: enableBorderColor ??
//                     context.enabledBorder.borderSide.color,
//                 width: context.enabledBorder.borderSide.width,
//               ),
//             )
//           : context.enabledBorder.copyWith(
//               borderSide: BorderSide(
//                 color: enableBorderColor ??
//                     context.enabledBorder.borderSide.color,
//                 width: context.enabledBorder.borderSide.width,
//               ),
//             ),
//       focusedBorder: borderRadius != null
//           ? OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(borderRadius ?? 6),
//               borderSide: BorderSide(
//                 color: focusBorderColor ??
//                     context.focusedBorder.borderSide.color,
//                 width: context.focusedBorder.borderSide.width,
//               ),
//             )
//           : context.focusedBorder.copyWith(
//               borderSide: BorderSide(
//                 color: focusBorderColor ??
//                     context.focusedBorder.borderSide.color,
//                 width: context.focusedBorder.borderSide.width,
//               ),
//             ),
//       errorBorder: borderRadius != null
//           ? OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(borderRadius ?? 6),
//               borderSide: BorderSide(
//                 color: errorBorderColor ??
//                     context.errorBorder.borderSide.color,
//                 width: context.errorBorder.borderSide.width,
//               ),
//             )
//           : context.errorBorder.copyWith(
//               borderSide: BorderSide(
//                 color: errorBorderColor ??
//                     context.errorBorder.borderSide.color,
//                 width: context.errorBorder.borderSide.width,
//               ),
//             ),
//       focusedErrorBorder: borderRadius != null
//           ? OutlineInputBorder(
//               borderRadius:
//                   BorderRadius.circular(borderRadius ?? 6),
//               borderSide: BorderSide(
//                 color: errorBorderColor ??
//                     context.focusedErrorBorder.borderSide.color,
//                 width: context.focusedErrorBorder.borderSide.width,
//               ),
//             )
//           : context.focusedErrorBorder.copyWith(
//               borderSide: BorderSide(
//                 color: errorBorderColor ??
//                     context.focusedErrorBorder.borderSide.color,
//                 width: context.focusedErrorBorder.borderSide.width,
//               ),
//             ),
//       fillColor: fillColor ?? context.fillColor,
//       filled: true,
//       alignLabelWithHint: true,
//       focusColor: context.primaryColor,
//       errorStyle: context.bodySmall.copyWith(
//         color: errorColor ?? context.errorColor,
//       ),
//       errorMaxLines: 2,
//     );
//   }
//
//   DateFormat get getFormat {
//     switch (dateTimeType) {
//       case DateTimeType.date:
//         return DateFormat('MMM dd, yyyy');
//
//       case DateTimeType.time:
//         return DateFormat('h:mm a');
//
//       case DateTimeType.dateTime:
//         return DateFormat('MMM dd, yyyy h:mm a');
//
//       case DateTimeType.month:
//         return DateFormat('MMMM');
//
//       case DateTimeType.year:
//         return DateFormat('yyyy');
//
//       case DateTimeType.monthYear:
//         return DateFormat("MMMM, yyyy");
//
//       default:
//         return DateFormat('MMM dd, yyyy h:mm a');
//     }
//   }
//
//   static Widget getTheme(BuildContext context, Widget? child) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         useMaterial3: false,
//         colorScheme: const ColorScheme.light(
//           primary:  context.primaryColor,
//           onSurface:  context.primaryColor,
//           onBackground:  context.primaryColor,
//         ),
//         dialogTheme: DialogTheme(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         timePickerTheme: TimePickerThemeData(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           helpTextStyle: context.bodyMedium.copyWith(color:  context.primaryColor),
//         ),
//         textButtonTheme: TextButtonThemeData(
//           style: TextButton.styleFrom(
//             foregroundColor:  context.primaryColor,
//           ),
//         ),
//       ),
//       child: child!,
//     );
//   }
// }
