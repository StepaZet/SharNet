import 'package:client/api/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:client/models/config.dart';
import 'package:client/models/shark.dart';

Future<SharkSearchInfo> searchShark(String query) async {
  await getUserInfo();

  String url = "${Config.apiUrl}/sharks/get_by_name/$query/";

  Map<String, String> headers = {};

  if (Config.accessToken != null) {
    headers['Authorization'] = 'Bearer ${Config.accessToken}';
    headers['Content-Type'] = 'application/json';
  }

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return SharkSearchInfo.fromJson(data);
  }

  return SharkSearchInfo(sharks: []);
}

Future<SharkFullInfo> getSharkFullInfo(String sharkId) async {
  await getUserInfo();

  String url = "${Config.apiUrl}/sharks/get_by_id/$sharkId/";

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    return SharkFullInfo.fromJson(data);
  }


  return SharkFullInfo(
    id: sharkId,
    name: "Great White Shark",
    photo: Config.defaultSharkUrl,
    length: 5.5,
    weight: 1200.0,
    sex: "Female",
    age: "10 years",
    tracks: 15,
    description: "A detailed description of the shark.",

    passedMiles: 2500.0,
    deploymentLength: "5 years",
    firstTagged: "2019-01-01",
    lastTagged: "2024-01-01",

    buoysList: [],

    topLength: [],
    topWeight: [],

    averageLength: 4.5,
    averageWeight: 1100.0,
  );
}