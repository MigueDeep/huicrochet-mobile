import 'package:huicrochet_mobile/modules/entities/address.dart';
import 'package:huicrochet_mobile/modules/entities/carItem.dart';
import 'package:huicrochet_mobile/modules/entities/payment_method.dart';
import 'package:huicrochet_mobile/modules/entities/user.dart';

class OrderDetails {
  final String id;
  final DateTime orderDate;
  final String status;
  final Address shippingAddress;
  final PaymentMethod paymentMethod;
  final User user;
  final List<CartItem> products;
  final double totalPrice;

  OrderDetails({
    required this.id,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.products,
    required this.user,
    required this.totalPrice,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json['id'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      shippingAddress:
          Address.fromJson(json['shippingAddress'] as Map<String, dynamic>),
      paymentMethod:
          PaymentMethod.fromJson(json['paymentMethod'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>)
          .map((product) => CartItem.fromJson(product as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
      'shippingAddress': shippingAddress.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'products': products.map((product) => product.toJson()).toList(),
      'totalPrice': totalPrice,
    };
  }
}
