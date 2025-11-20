import 'package:equatable/equatable.dart';
import '../../../data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final num total;

  const CartLoaded({
    this.items = const [],
    this.total = 0,
  });

  @override
  List<Object> get props => [items, total];
}
