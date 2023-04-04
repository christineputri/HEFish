import 'dart:convert';

List<Fishes> postFromJson(String str) =>
    List<Fishes>.from(json.decode(str).map((x) => Fishes.fromMap(x)));

class Fishes {
  Fishes({
    required this.id,
    required this.name,
    // required this.description,
    // required this.price,
    // required this.image_path
  });

  int id;
  String name;

  factory Fishes.fromMap(Map<String, dynamic> json) => Fishes(
        id: json["id"],
        name: json["name"],
        // description: json["description"],
        // price: json["price"],
        // image_path: json["image_path"]
      );
}
