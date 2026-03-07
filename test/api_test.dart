import "package:desco_usage/api/api.dart";

Future<void> main() async {
  final meterInfo = MeterInfo.fromAccountNo("41139960");

  // final res = await getCustomerInfo(meterInfo);

  // final today = Date.now();
  // final from = Date(year: 2025, month: 03, day: 06);
  // // final res = await getDailyConsumptions(meterInfo, from, today);
  // final res = await getRechargeHistorys(meterInfo, from, today);

  final res = await getBalance(meterInfo);

  // final today = Month.now();
  // final from = Month(year: 2025, month: 03);
  // final res = await getMonthlyConsumption(meterInfo, from, today);
  
  print(res);
}
