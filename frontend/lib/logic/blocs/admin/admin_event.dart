import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class LoadAllUsers extends AdminEvent {}

class LoadAllOrders extends AdminEvent {}

class LoadAllProducts extends AdminEvent {}

class DeleteUser extends AdminEvent {
  final String id;

  const DeleteUser(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteOrder extends AdminEvent {
  final String id;

  const DeleteOrder(this.id);

  @override
  List<Object> get props => [id];
}

class DeleteProduct extends AdminEvent {
  final String id;

  const DeleteProduct(this.id);

  @override
  List<Object> get props => [id];
}

class MarkDelivered extends AdminEvent {
  final String id;

  const MarkDelivered(this.id);

  @override
  List<Object> get props => [id];
}
