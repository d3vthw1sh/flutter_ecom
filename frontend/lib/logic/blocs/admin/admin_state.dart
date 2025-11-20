import 'package:equatable/equatable.dart';
import '../../../data/models/user.dart';
import '../../../data/models/order.dart';
import '../../../data/models/product.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminLoading extends AdminState {}

class AdminUsersLoaded extends AdminState {
  final List<User> users;

  const AdminUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

class AdminOrdersLoaded extends AdminState {
  final List<Order> orders;

  const AdminOrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class AdminProductsLoaded extends AdminState {
  final List<Product> products;

  const AdminProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class AdminActionSuccess extends AdminState {}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object> get props => [message];
}
