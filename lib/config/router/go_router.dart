import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smartory_app/presentation/providers/auth/auth_provider.dart';
import 'package:smartory_app/presentation/providers/auth/auth_router_provider.dart';
import 'package:smartory_app/presentation/screens/scanner/barcore_scanner.dart';
import 'package:smartory_app/presentation/widgets/layout/main_layout.dart';

import '../../presentation/screens/screens.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.read(routerRefreshProvider);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(
        path: '/',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: '/inventory',
            name: 'inventory',
            builder: (context, state) => InventoryScreen(),
          ),
          GoRoute(
            path: '/catalog',
            name: 'catalog',
            builder: (context, state) => CatalogScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/camera',
        name: 'camera',
        builder: (context, state) => TakePictureScreen(),
      ),
      GoRoute(
        path: '/barcode-scanner',
        name: 'barcode-scanner',
        builder: (context, state) => MobileScannerSimple(),
      ),
    ],
    redirect: (context, state) {
      final authAsync = ref.read(authProvider);

      final isLoading = authAsync.isLoading;
      final authState = authAsync.value;
      final isAuthenticated = authState?.status == AuthStatus.authenticated;

      final goingToLogin = state.matchedLocation == '/';

      if (isLoading) return null;

      if (!isAuthenticated && !goingToLogin) return '/';

      if (isAuthenticated && goingToLogin) return '/home';

      return null;
    },
  );
});
