class UnitRange {
  UnitRange({required this.start, this.end});

  double start;
  double? end;
}

class SlabRate {
  SlabRate({required this.range, required this.price});

  UnitRange range;
  double price;
}

class FixedRate {
  const FixedRate({
    required this.peak,
    required this.offPeak,
    this.superOffPeak,
  });

  final double peak;
  final double offPeak;
  final double? superOffPeak;
}

enum TariffCategory {
  lowTensionA,
  lowTensionE;

  String code() {
    return switch (this) {
      TariffCategory.lowTensionA => "LT-A",
      TariffCategory.lowTensionE => "LT-E",
    };
  }

  String type() {
    return switch (this) {
      TariffCategory.lowTensionA => "residential",
      TariffCategory.lowTensionE => "commercial",
    };
  }

  static TariffCategory? fromCode(String input) {
    final match = RegExp(
      r'LT-([A-Z]+\d*)',
      caseSensitive: false,
    ).firstMatch(input);

    final letters = match?.group(1)?.toUpperCase();

    return switch (letters) {
      "A" => TariffCategory.lowTensionA,
      "E" => TariffCategory.lowTensionE,
      _ => null,
    };
  }

  static TariffCategory? fromCategorySolution(String input) {
    final match = RegExp(
      r'Category-([A-Z])',
      caseSensitive: false,
    ).firstMatch(input);

    final letter = match?.group(1)?.toUpperCase();

    return switch (letter) {
      "A" => TariffCategory.lowTensionA,
      "E" => TariffCategory.lowTensionE,
      _ => null,
    };
  }
}

// ===========================================================================

abstract class ElectricityTariff {
  double get demandCharge;
  TariffCategory get category;
  final SlabRate? lifeLine = null;
  final List<SlabRate> slabs = [];
}

class ResidentialTariff implements ElectricityTariff {
  @override
  final double demandCharge = 42.00;

  @override
  TariffCategory category = TariffCategory.lowTensionA;

  @override
  final SlabRate? lifeLine = SlabRate(
    range: UnitRange(start: 0, end: 50),
    price: 4.63,
  );

  @override
  final slabs = [
    SlabRate(range: UnitRange(start: 1, end: 75), price: 5.26),
    SlabRate(range: UnitRange(start: 76, end: 200), price: 7.20),
    SlabRate(range: UnitRange(start: 201, end: 300), price: 7.59),
    SlabRate(range: UnitRange(start: 301, end: 400), price: 8.02),
    SlabRate(range: UnitRange(start: 401, end: 600), price: 12.67),
    SlabRate(range: UnitRange(start: 601), price: 14.61),
  ];
}

class CommercialTariff extends ElectricityTariff {
  @override
  final TariffCategory category = TariffCategory.lowTensionE;

  @override
  final double demandCharge = 90;

  final FixedRate rates = const FixedRate(peak: 15.62, offPeak: 11.71);
}

class TariffCatalog {
  static final List<ElectricityTariff> tariffs = [ResidentialTariff()];

  static ElectricityTariff get(TariffCategory catagory) {
    return tariffs.firstWhere(
      (t) => t.category == catagory,
      orElse: () => throw Exception("Tariff not found for ${catagory.code()}"),
    );
  }
}
