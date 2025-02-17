import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  final format = NumberFormat('#,##0.00', 'en_US');
  return format.format(amount);
}
