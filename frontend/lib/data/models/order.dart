class OrderItem {
  final String name;
  final int qty;
  final String image;
  final num price;
  final String product;

  OrderItem({
    required this.name,
    required this.qty,
    required this.image,
    required this.price,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'] ?? '',
      qty: json['qty'] ?? 0,
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      product: json['product'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'qty': qty,
      'image': image,
      'price': price,
      'product': product,
    };
  }
}

class Order {
  final String id;
  final List<OrderItem> orderItems;
  final Map<String, dynamic> shippingAddress;
  final num subtotal;
  final num shippingPrice;
  final num totalPrice;
  final String paymentStatus;
  final bool isDelivered;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.orderItems,
    required this.shippingAddress,
    required this.subtotal,
    required this.shippingPrice,
    required this.totalPrice,
    required this.paymentStatus,
    required this.isDelivered,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      orderItems: (json['orderItems'] as List?)
              ?.map((i) => OrderItem.fromJson(i))
              .toList() ??
          [],
      shippingAddress: json['shippingAddress'] ?? {},
      subtotal: json['subtotal'] ?? 0,
      shippingPrice: json['shippingPrice'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      isDelivered: json['isDelivered'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'orderItems': orderItems.map((i) => i.toJson()).toList(),
      'shippingAddress': shippingAddress,
      'subtotal': subtotal,
      'shippingPrice': shippingPrice,
      'totalPrice': totalPrice,
      'paymentStatus': paymentStatus,
      'isDelivered': isDelivered,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
