import 'package:desco_usage/api/api.dart';
import 'package:desco_usage/api/customer.dart';
import 'package:desco_usage/signal.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final Future<AppInstance> _appInstance;

Future<T?> _loadData<T>(Future<T> Function() cb) async {
  isLoading.set(isLoading.value + 1);
  try {
    return await cb();
  } catch (err) {
    // print(err);
  } finally {
    isLoading.set(isLoading.value - 1);
  }
  return null;
}

class MeterInfo {
  Balance balance;

  MeterInfo({required this.balance});
}

final selectedNav = CreateState(0);
final isLoading = CreateState(0);

CreateState<List<MeterInfo>> meterInfos = CreateState([]);

void addMeter(MeterNo meterNo) async {
  final balance = await _loadData(() => getBalance(meterNo));

  if (balance == null) {
    return;
  }

  // cheak if meter already added
  if (meterInfos.value.any(
    (meter) => meter.balance.meterNo == balance.data.meterNo,
  )) {
    return;
  }

  meterInfos.update((list) {
    meterInfos.value.add(MeterInfo(balance: balance.data));
  });

  AppInstance.get((app) {
    app.sharedPreferences.setStringList(
      "meters",
      meterInfos.value.map((meter) => meter.balance.meterNo).toList(),
    );
  });
}

class AppInstance {
  SharedPreferences sharedPreferences;
  AppInstance({required this.sharedPreferences});

  static void get(void Function(AppInstance) fn) {
    _appInstance.then(fn, onError: (_) => {});
  }

  static void init() {
    Future<AppInstance> initInstance() async {
      final sharedPreferences = await SharedPreferences.getInstance();

      final meters = sharedPreferences.getStringList("meters") ?? [];

      final getBalances = meters
          .map(MeterNo.from)
          .whereType<MeterNo>()
          .map((meterNo) => _loadData(() => getBalance(meterNo)));

      final balances = await Future.wait(getBalances);

      final data = balances
          .map((res) => res?.data)
          .whereType<Balance>()
          .map((balance) => MeterInfo(balance: balance))
          .toList();

      meterInfos.set(data);

      return AppInstance(sharedPreferences: sharedPreferences);
    }

    _appInstance = initInstance();
  }
}
