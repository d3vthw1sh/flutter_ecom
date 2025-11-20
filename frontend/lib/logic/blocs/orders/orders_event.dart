import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class LoadMyOrders extends OrdersEvent {}

class CreateOrder extends OrdersEvent {
  final Map<String, dynamic> data;

  const CreateOrder(this.data);

  @override
  List<Object> get props => [data];
}
