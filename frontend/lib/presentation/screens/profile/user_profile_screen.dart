import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../logic/blocs/auth/auth_bloc.dart';
import '../../../logic/blocs/auth/auth_event.dart';
import '../../../logic/blocs/auth/auth_state.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/bottom_nav.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'Profile',
        showBack: false,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 16),
                Text(
                  user.username,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                ListTile(
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: const Text('Order History'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/orders'),
                ),
                const Divider(),
                if (user.isAdmin) ...[
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined),
                    title: const Text('Admin Console'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/admin'),
                  ),
                  const Divider(),
                ],
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                ),
              ],
            );
          }
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Please login to view your profile'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
