class CacheKey {
  CacheKey({required this.meterNo});
  final String meterNo;
  String customarInfoCKey() => "_CI_$meterNo";
}
