class Config {
  static DateTime defaultStartDate = DateTime.now().subtract(const Duration(days: 7));
  static DateTime defaultEndDate = DateTime.now();

  static const String simpleMapUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String realisticMapUrl = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
  static const String defaultBuoyUrl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Boje_iin_kieler_f%C3%B6rde.JPG/800px-Boje_iin_kieler_f%C3%B6rde.JPG';
  static const String defaultSharkUrl = 'https://cdn.mos.cms.futurecdn.net/yBBaWKG8MiNNAVfE4Z2aRJ-1200-80.jpg';

  static const String defaultSharkMarkerUrl = 'https://cdn-icons-png.flaticon.com/512/416/416308.png';
}
