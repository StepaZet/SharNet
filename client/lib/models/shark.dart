import 'package:client/models/track.dart';

class Shark {
  final String id;
  final String name;
  final int length;
  final int weight;
  final String sex;
  final List<Track> tracks;
  final int age;

  Shark({
    required this.id,
    required this.age,
    required this.name,
    required this.length,
    required this.weight,
    required this.sex,
    required this.tracks,
});
}
