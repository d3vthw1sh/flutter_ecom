import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Dependency Injection
import 'dependency_injection.dart';

// Theme
import 'core/theme.dart';

// Router
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: globalProviders(),
      child: MaterialApp.router(
        title: 'RUPPTECH',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
