import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/auth_provider.dart';

// Screens
import '../screens/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';

import '../screens/home/main_screen.dart';

import '../screens/product/product_detail_screen.dart';
import '../screens/product/category_screen.dart';

import '../screens/cart/cart_screen.dart';
import '../screens/cart/checkout_screen.dart';

import '../screens/order/order_success_screen.dart';
import '../screens/order/order_tracking_screen.dart';
import '../screens/order/order_history_screen.dart';

import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';

import '../screens/promotion_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',

    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;

      final isOnboarding = state.uri.path == '/onboarding';
      final isLogin = state.uri.path == '/login';
      final isRegister = state.uri.path == '/register';
      final isForgotPassword = state.uri.path == '/forgot-password';

      // Jika belum login dan masuk ke route terlindungi → balik ke onboarding
      if (!isAuthenticated &&
          !isOnboarding &&
          !isLogin &&
          !isRegister &&
          !isForgotPassword) {
        return '/onboarding';
      }

      // Jika sudah login dan coba buka halaman auth → lempar ke home
      if (isAuthenticated &&
          (isOnboarding || isLogin || isRegister)) {
        return '/home';
      }

      return null;
    },

    routes: [

      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(),
      ),

      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailScreen(productId: id);
        },
      ),

      GoRoute(
        path: '/category',
        builder: (context, state) => const CategoryScreen(),
      ),

      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),

      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),

      GoRoute(
        path: '/order-success',
        builder: (context, state) => const OrderSuccessScreen(),
      ),

      GoRoute(
        path: '/order-tracking/:id',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderTrackingScreen(orderId: orderId);
        },
      ),

      GoRoute(
        path: '/order-history',
        builder: (context, state) => const OrderHistoryScreen(),
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),

      GoRoute(
        path: '/promotions',
        builder: (context, state) => const PromotionScreen(),
      ),
    ],
  );
}