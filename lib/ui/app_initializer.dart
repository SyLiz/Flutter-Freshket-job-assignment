import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_job_assignment/route/go_route.dart';
import 'package:flutter_job_assignment/view_model/cart_view_model.dart';
import 'package:flutter_job_assignment/view_model/shopping_view_model.dart';
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../utils/dio_service.dart';

class AppInitializer {
  static Future<void> initializeApp(EnvironmentConfig config) async {
    WidgetsFlutterBinding.ensureInitialized();
    // Perform initialization tasks like API calls, Firebase setup, etc.
    await Future.delayed(Duration(milliseconds: 100)); // Simulating initialization

    DioService.getInstance(baseUrl: config.baseURL);

    runApp(const AppInitializerPage());
  }
}

class AppInitializerPage extends StatelessWidget {
  const AppInitializerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => ShoppingViewModel()),
        ChangeNotifierProvider(create: (c) => CartViewModel()),
      ],
      child: MaterialApp.router(
        title: 'Freshket Job Assignment. Pongsatorn Ploypukdee',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
