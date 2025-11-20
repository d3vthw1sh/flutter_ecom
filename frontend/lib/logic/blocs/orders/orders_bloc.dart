import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/order_service.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderService _orderService;

  OrdersBloc({required OrderService orderService})
      : _orderService = orderService,
        super(OrdersLoading()) {
    on<LoadMyOrders>(_onLoadMyOrders);
    on<CreateOrder>(_onCreateOrder);
  }

  Future<void> _onLoadMyOrders(
    LoadMyOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await _orderService.getMyOrders();
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final order = await _orderService.createOrder(event.data);
      emit(OrderCreated(order));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}
