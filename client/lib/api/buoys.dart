import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import '../models/buoy.dart';
import '../models/config.dart';

Future<BuoySearchInfo> searchBuoy(String query) async {
  String url = "${Config.apiUrl}/buoys/get_by_name/$query/";

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return BuoySearchInfo.fromJson(data);
  }

  return BuoySearchInfo(buoys: []);
}


Future<BuoyFullInfo> getBuoyFullInfo(String buoyId) async {
  String url = "${Config.apiUrl}/buoys/get_by_id/$buoyId/";

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return BuoyFullInfo.fromJson(data);
  }


  return BuoyFullInfo(
    id: buoyId,
    name: "Buoy Name",
    photo: Config.defaultBuoyUrl,
    location: LatLng(37.4219983, -122.0840579),
    status: "Active",
    pings: 20,
    activeBuoyDays: 365,
    detectedSharks: 5,
    dateOfPlacement: "2023-01-01",
    description: "Detailed description of the buoy.",
    lastPing: "2024-01-07",
    sharksList: [],
  );
}