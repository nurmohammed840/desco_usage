import './tariff.dart';

double calculateEnergyCost(double units, ElectricityTariff provider) {
  double cost = 0;
  double remaining = units;

  for (var tariff in provider.slabs) {
    double slabFrom = tariff.range.start;
    double slabTo =
        tariff.range.end ?? units; // if `to` is null, treat as infinite

    // Calculate units in this slab
    double slabUnits = 0;
    if (remaining > 0) {
      // slabUnits = slabTo - slabFrom + 1;

      slabUnits = (remaining + slabFrom > slabTo)
          ? (slabTo - slabFrom + 1)
          : remaining;

      cost += slabUnits * tariff.price;

      // print(
      //   "slabUnits: $slabUnits * ${tariff.price} = ${slabUnits * tariff.price}; cost = $cost",
      // );

      remaining -= slabUnits;
    }
  }

  return cost;
}

double calculateUnitFromEnergyCost(double cost, ElectricityTariff provider) {
  double remainingCost = cost;

  final lifeLine = provider.lifeLine;
  if (lifeLine != null) {
    final slabUnits = lifeLine.range.end ?? 0;
    final maxCost = slabUnits * lifeLine.price;

    if (remainingCost <= maxCost) {
      return remainingCost / lifeLine.price;
    }
  }

  double unit = 0;

  for (final tariff in provider.slabs) {
    double slabFrom = tariff.range.start;
    double slabTo =
        tariff.range.end ??
        double.infinity; // if `to` is null, treat as infinite

    double slabUnits = (slabTo - slabFrom + 1);
    double slabCost = slabUnits * tariff.price;

    if (remainingCost > slabCost) {
      unit += slabUnits;
      remainingCost -= slabCost;
    } else {
      unit += remainingCost / tariff.price;
      break;
    }
  }
  return unit;
}

double calculateTotalBill(
  double energyCost, {
  double demand = 42,
  double load = 1,
  double vat = 0.05,
}) {
  double baseBill = energyCost + (demand * load);
  double vatAmount = baseBill * vat;
  return baseBill + vatAmount;
}
