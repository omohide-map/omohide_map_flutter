import 'package:go_router/go_router.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:omohide_map_flutter/views/home/home_page.dart';
import 'package:omohide_map_flutter/views/login/login_page.dart';
import 'package:provider/provider.dart';
import 'constants/routes.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.login,
  redirect: (context, state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLoggedIn = authProvider.isLoggedIn;
    final isLoggingIn = state.matchedLocation == Routes.login;

    if (!isLoggedIn && !isLoggingIn) {
      return Routes.login;
    }

    if (isLoggedIn && isLoggingIn) {
      return Routes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const LoginPage(),
    ),
  ],
);
