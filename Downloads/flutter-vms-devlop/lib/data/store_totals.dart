class StoreTotals {
  final String totalStores;
  final String totalCameras;
  final String theftsDetected;
  final String theftsPrevented;

  StoreTotals({
    required this.totalStores,
    required this.totalCameras,
    required this.theftsDetected,
    required this.theftsPrevented,
  });

  factory StoreTotals.defaultValues() {
    return StoreTotals(
      totalStores: "0",
      totalCameras: "0",
      theftsDetected: "0",
      theftsPrevented: "0",
    );
  }
}
