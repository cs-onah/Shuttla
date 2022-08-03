import 'package:intl/intl.dart';

class ShuttlaUtility{

  static String formatReadableDateString(String date, {bool timeInclusive = true}){
    try{
      DateTime formatted = DateTime.parse(date);
      DateFormat format = DateFormat.yMMMd();
      if(timeInclusive) format.add_jm();
      return format.format(formatted);
    } catch (e){
      print("Cannot parse $date");
    }
    return "";
  }

  static String formatReadableDateTime(DateTime date, {bool timeInclusive = true}){
    try{
      DateFormat format = DateFormat.yMMMd();
      if(timeInclusive) format.add_jm();
      return format.format(date);
    } catch (e){
      print("Cannot format $date");
    }
    return "";
  }

  static String separateAmount(double value){
    var formatter = NumberFormat('##,###,##0.##');
    return formatter.format(value);
  }

  static String? convertDistance(double? value){
    if (value == null) return null;
    String unit = "m";
    if(value > 1000) {
      unit = "km";
      value = value / 1000;
    }
    return separateAmount(value) + " $unit";
  }
}