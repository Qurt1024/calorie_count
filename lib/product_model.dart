class Product {
  final String id;
  final String name;
  final int calories;
  final String? imagePath;

  Product({
    String? id,
    required this.name,
    required this.calories,
    this.imagePath,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Product copyWith({
    String? id,
    String? name,
    int? calories,
    String? imagePath,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'imagePath': imagePath,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String,
      calories: json['calories'] as int,
      imagePath: json['imagePath'] as String?,
    );
  }
}
