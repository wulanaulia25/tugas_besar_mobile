
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/theme_provider.dart';
import 'services/api_service.dart';

import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiService = ApiService(); // kamu pasti punya ini di api_service.dart

  runApp(FoodDeliveryApp(
    prefs: prefs,
    apiService: apiService,
  ));
}

class FoodDeliveryApp extends StatelessWidget {
  final SharedPreferences prefs;
  final ApiService apiService;

  const FoodDeliveryApp({
    super.key,
    required this.prefs,
    required this.apiService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),

        ChangeNotifierProvider(create: (_) => ProductProvider(apiService)),

        ChangeNotifierProvider(create: (_) => CartProvider(prefs)),

        ChangeNotifierProvider(create: (_) => OrderProvider(apiService)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Storely App',
            routerConfig: AppRouter.router,
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: GoogleFonts.poppinsTextTheme(
                ThemeData.dark().textTheme,
              ),
            ),
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
          );
        },
      ),
    );
  }
}
