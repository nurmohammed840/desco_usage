import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'utils.dart';

import '/app_state.dart';
import '/components/center_widget.dart';

class UsageScreen extends AppScreen {
  const UsageScreen({super.key});

  @override
  final title = "Usage";

  @override
  Widget build(BuildContext context) {
    return meterInfos.watch((_) {
      if (meterInfos.value.isEmpty) {
        return const CenterWidget(
          iconData: Icons.electric_meter_outlined,
          header: "No Meter Found",
          msg: "",
        );
      }
      return ListView.separated(
        itemCount: meterInfos.value.length,
        separatorBuilder: (_, _) => const Padding(
          padding: .symmetric(horizontal: 16.0),
          child: Divider(color: Colors.grey, thickness: 0.5),
        ),
        itemBuilder: (_, index) {
          final meter = meterInfos.value[index].balance;

          return ListTile(
            leading: const Icon(Icons.electric_meter),
            title: Text(
              meter.accountNo,
              style: const TextStyle(
                fontWeight: FontWeight.w500, // make title bold
              ),
            ),
            // subtitle: Text(balance.meterNo),
            subtitle: Column(
              crossAxisAlignment: .start,
              children: [
                Text("# ${meter.meterNo}"),
                Text("${meter.currentMonthConsumption.toStringAsFixed(2)} kWh"),
                Text(
                  DateFormat('dd MMM yyyy').format(meter.readingTime.time()),
                ),
              ],
            ),
            trailing: Text(
              meter.balance.toStringAsFixed(2), // show balance on the right
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            iconColor: Colors.blue[700],
            onTap: () => {},
          );
        },
      );
    });
  }
}
