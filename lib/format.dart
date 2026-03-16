import 'package:intl/intl.dart';

final dateFormatter = DateFormat('d MMM yyyy, h:mm a');
final dateFormatterAlt = DateFormat('d MMM');
final dateFormatterAltFull = DateFormat('d MMMM');
final dateFormatterDefault = DateFormat('d MMMM yyyy');

final balanceFormatter = NumberFormat('#,##0.##');