import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smartory_app/presentation/providers/auth_provider.dart';
import 'package:smartory_app/presentation/providers/auth_router_provider.dart';

import '../../presentation/screens/screens.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.read(routerRefreshProvider);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(path: '/', name: 'login', builder: (context, state) => LoginScreen()),
      GoRoute(path: '/home', name: 'home', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/inventory', name: 'inventory', builder: (context, state) => InventoryScreen()),
    ],
    redirect: (context, state) {
      final authAsync = ref.read(authProvider);

      final isLoading = authAsync.isLoading;
      final authState = authAsync.value;
      final isAuthenticated = authState?.status == AuthStatus.authenticated;

      final goingToLogin = state.matchedLocation == '/';

      if ( isLoading ) return null;

      if (!isAuthenticated && !goingToLogin) return '/';

      if (isAuthenticated && goingToLogin) return '/home';

      return null;
    },
  );
});

