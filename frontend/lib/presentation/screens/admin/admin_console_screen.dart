import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/blocs/admin/admin_bloc.dart';
import '../../../logic/blocs/admin/admin_event.dart';
import '../../../logic/blocs/admin/admin_state.dart';
import '../../../core/utils.dart';
import 'users_tab.dart';
import 'orders_tab.dart';
import 'products_tab.dart';

class AdminConsoleScreen extends StatefulWidget {
  const AdminConsoleScreen({super.key});

  @override
  State<AdminConsoleScreen> createState() => _AdminConsoleScreenState();
}

class _AdminConsoleScreenState extends State<AdminConsoleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadTabData(_tabController.index);
      }
    });
    _loadTabData(0);
  }

  void _loadTabData(int index) {
    switch (index) {
      case 0:
        context.read<AdminBloc>().add(LoadAllUsers());
        break;
      case 1:
        context.read<AdminBloc>().add(LoadAllOrders());
        break;
      case 2:
        context.read<AdminBloc>().add(LoadAllProducts());
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users', icon: Icon(Icons.people)),
            Tab(text: 'Orders', icon: Icon(Icons.shopping_bag)),
            Tab(text: 'Products', icon: Icon(Icons.inventory)),
          ],
        ),
      ),
      body: BlocListener<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminActionSuccess) {
            AppUtils.showToast('Action completed successfully');
            _loadTabData(_tabController.index);
          } else if (state is AdminError) {
            AppUtils.showToast('Error: ${state.message}');
          }
        },
        child: TabBarView(
          controller: _tabController,
          children: const [
            UsersTab(),
            OrdersTab(),
            ProductsTab(),
          ],
        ),
      ),
    );
  }
}
