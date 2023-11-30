class Buoy {
  final String name;
  final String id;
  final String status;
  final double longitude;
  final double latitude;
  final int pings;
  final int detectedSharks;
  final int detectedTracks;
  final int activeDays = 7;
  final String dateOfPlacement = "2021-10-10";
  final String lastPing = "2021-10-10";

  Buoy({
    required this.name,
    required this.id,
    required this.status,
    required this.longitude,
    required this.latitude,
    required this.pings,
    required this.detectedSharks,
    required this.detectedTracks
  });
}
