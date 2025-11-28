import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_state.dart';
import '../../logic/blocs/cart/cart_bloc.dart';
import '../../logic/blocs/cart/cart_state.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSearch;
  final bool showCart;
  final bool showProfile;
  final bool showBack;

  const AppAppBar({
    super.key,
    this.title = 'RUPPTECH',
    this.showSearch = true,
    this.showCart = true,
    this.showProfile = true,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/products');
                }
              },
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        if (showSearch)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
        if (showCart)
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int count = 0;
              if (state is CartLoaded) {
                count = state.items.length;
              }
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => context.push('/cart'),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        if (showProfile)
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  if (state is AuthAuthenticated) {
                    context.push('/profile');
                  } else {
                    context.push('/login');
                  }
                },
              );
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
