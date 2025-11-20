import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncreaseQty>(_onIncreaseQty);
    on<DecreaseQty>(_onDecreaseQty);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('cart');
      if (cartString != null) {
        final List<dynamic> jsonList = json.decode(cartString);
        final items = jsonList.map((e) => CartItem.fromJson(e)).toList();
        emit(CartLoaded(items: items, total: _calculateTotal(items)));
      } else {
        emit(const CartLoaded(items: [], total: 0));
      }
    } catch (_) {
      emit(const CartLoaded(items: [], total: 0));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final List<CartItem> updatedItems = List.from(currentState.items);
      final index = updatedItems.indexWhere((item) => item.id == event.product.id);

      if (index >= 0) {
        final existingItem = updatedItems[index];
        updatedItems[index] = existingItem.copyWith(qty: existingItem.qty + 1);
      } else {
        updatedItems.add(CartItem(
          id: event.product.id,
          name: event.product.name,
          image: event.product.images.isNotEmpty ? event.product.images.first : '',
          price: event.product.price,
          stock: event.product.stock,
          qty: 1,
          brand: event.product.brand,
        ));
      }

      await _saveCart(updatedItems);
      emit(CartLoaded(items: updatedItems, total: _calculateTotal(updatedItems)));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems = currentState.items
          .where((item) => item.id != event.id)
          .toList();
      await _saveCart(updatedItems);
      emit(CartLoaded(items: updatedItems, total: _calculateTotal(updatedItems)));
    }
  }

  Future<void> _onIncreaseQty(IncreaseQty event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems = currentState.items.map((item) {
        if (item.id == event.id) {
          return item.copyWith(qty: item.qty + 1);
        }
        return item;
      }).toList();
      await _saveCart(updatedItems);
      emit(CartLoaded(items: updatedItems, total: _calculateTotal(updatedItems)));
    }
  }

  Future<void> _onDecreaseQty(DecreaseQty event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      final updatedItems = currentState.items.map((item) {
        if (item.id == event.id && item.qty > 1) {
          return item.copyWith(qty: item.qty - 1);
        }
        return item;
      }).toList();
      await _saveCart(updatedItems);
      emit(CartLoaded(items: updatedItems, total: _calculateTotal(updatedItems)));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    await _saveCart([]);
    emit(const CartLoaded(items: [], total: 0));
  }

  Future<void> _saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      items.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('cart', encodedData);
  }

  num _calculateTotal(List<CartItem> items) {
    return items.fold(0, (total, item) => total + (item.price * item.qty));
  }
}
