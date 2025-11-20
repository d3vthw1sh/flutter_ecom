import 'package:equatable/equatable.dart';
import '../../../data/models/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final String id;

  const RemoveFromCart(this.id);

  @override
  List<Object> get props => [id];
}

class IncreaseQty extends CartEvent {
  final String id;

  const IncreaseQty(this.id);

  @override
  List<Object> get props => [id];
}

class DecreaseQty extends CartEvent {
  final String id;

  const DecreaseQty(this.id);

  @override
  List<Object> get props => [id];
}

class ClearCart extends CartEvent {}
