import 'package:go_router/go_router.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:omohide_map_flutter/views/home/home_page.dart';
import 'package:omohide_map_flutter/views/login/login_page.dart';
import 'package:omohide_map_flutter/views/post/post_page.dart';
import 'constants/routes.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: Routes.login,
    refreshListenable: authProvider,
    redirect: (context, state) {
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
      GoRoute(
        path: Routes.post,
        builder: (context, state) => const PostPage(),
      ),
    ],
  );
}
