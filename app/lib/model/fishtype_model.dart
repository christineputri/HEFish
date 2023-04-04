import 'dart:convert';

List<FishType> postFromJson(String str) =>
    List<FishType>.from(json.decode(str).map((x) => FishType.fromMap(x)));

class FishType {
  FishType({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory FishType.fromMap(Map<String, dynamic> json) => FishType(
        id: json["id"],
        name: json["name"],
      );
}
