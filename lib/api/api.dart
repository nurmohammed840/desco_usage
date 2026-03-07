import 'dart:convert';
import 'package:http/http.dart' as http;

import 'customer.dart';
import 'date.dart';

const apiUrl = "https://prepaid.desco.org.bd/api/unified/customer";

class MeterInfo {
  String? accountNo;
  String? meterNo;

  MeterInfo({this.accountNo, this.meterNo});
  MeterInfo.fromAccountNo(String account) : accountNo = account, meterNo = null;
  MeterInfo.fromMeterNo(String meter) : meterNo = meter, accountNo = null;

  @override
  String toString() {
    List<String> parts = [];
    if (accountNo != null) parts.add('accountNo=$accountNo');
    if (meterNo != null) parts.add('meterNo=$meterNo');
    return parts.join('&');
  }
}

Future<T> fetchJson<T>(
  String url,
  T Function(Map<String, dynamic>) fromJson,
) async {
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    return fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to load data, status: ${res.statusCode}');
  }
}

Future<Response<Info>> getCustomerInfo(MeterInfo meterInfo) async {
  final url = "$apiUrl/getCustomerInfo?$meterInfo";
  return fetchJson(url, parseResponse(Info.fromJson));
}

Future<Response<List<DailyConsumption>>> getDailyConsumptions(
  MeterInfo meterInfo,
  Date from,
  Date to,
) async {
  final url =
      "$apiUrl/getCustomerDailyConsumption?$meterInfo&dateFrom=$from&dateTo=$to";

  return fetchJson(url, parseResponseMany(DailyConsumption.fromJson));
}

Future<Response<Balance>> getBalance(MeterInfo meterInfo) async {
  final url = "$apiUrl/getBalance?$meterInfo";
  print(url);
  return fetchJson(url, parseResponse(Balance.fromJson));
}

Future<Response<List<RechargeHistory>>> getRechargeHistorys(
  MeterInfo meterInfo,
  Date from,
  Date to,
) async {
  final url = "$apiUrl/getRechargeHistory?$meterInfo&dateFrom=$from&dateTo=$to";
  return fetchJson(url, parseResponseMany(RechargeHistory.fromJson));
}

Future<Response<List<MonthlyConsumption>>> getMonthlyConsumption(
  MeterInfo meterInfo,
  Month from,
  Month to,
) async {
  final url =
      "$apiUrl/getCustomerMonthlyConsumption?$meterInfo&monthFrom=$from&monthTo=$to";

  return fetchJson(url, parseResponseMany(MonthlyConsumption.fromJson));
}
