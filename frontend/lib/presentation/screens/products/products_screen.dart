import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/blocs/products/products_bloc.dart';
import '../../../logic/blocs/products/products_event.dart';
import '../../../logic/blocs/products/products_state.dart';
import '../../../logic/blocs/auth/auth_bloc.dart';
import '../../../logic/blocs/auth/auth_state.dart';
import '../../widgets/product_card.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/bottom_nav.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(LoadProducts());
  }

  Future<void> _handleRefresh() async {
    context.read<ProductsBloc>().add(RefreshProducts());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'RUPPTECH',
        showBack: false,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Auth state changes handled by AppAppBar or other logic
        },
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductsBloc>().add(LoadProducts());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductsLoaded) {
              if (state.products.isEmpty) {
                return const Center(
                  child: Text('No products available'),
                );
              }

              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        context.go('/product/${product.id}');
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
