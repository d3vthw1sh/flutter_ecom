class CartItem {
  final String id;
  final String name;
  final String image;
  final num price;
  final int stock;
  final int qty;
  final String brand;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.stock,
    required this.qty,
    required this.brand,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
      qty: json['qty'] ?? 0,
      brand: json['brand'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'stock': stock,
      'qty': qty,
      'brand': brand,
    };
  }

  CartItem copyWith({
    String? id,
    String? name,
    String? image,
    num? price,
    int? stock,
    int? qty,
    String? brand,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      qty: qty ?? this.qty,
      brand: brand ?? this.brand,
    );
  }
}
