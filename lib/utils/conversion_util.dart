import 'package:intl/intl.dart';

class ConversionUtils {
  static final _currency =
      new NumberFormat.simpleCurrency(name: "Ksh ", locale: "en");
  static final _dateFormat = DateFormat();

  static String formatCurrency(dynamic currency) =>
      _currency.format(double.parse(currency));

  static DateTime formatDate(String longDate) => _dateFormat.parse(longDate);

  static String formatUtc(String longDate,
      {String format = "dd MMM yyyy  hh:mm aaa"}) {
    var strToDateTime = DateTime.parse(longDate).toLocal();
    return DateFormat(format).format(strToDateTime);
  }
}
