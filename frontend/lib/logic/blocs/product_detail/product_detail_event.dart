import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadProduct extends ProductDetailEvent {
  final String id;

  const LoadProduct(this.id);

  @override
  List<Object> get props => [id];
}
