import 'package:go_router/go_router.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:omohide_map_flutter/views/home/home_view_model.dart';
import 'package:omohide_map_flutter/views/login/login_view_model.dart';
import 'package:omohide_map_flutter/views/post/post_view_model.dart';
import 'package:omohide_map_flutter/views/home/home_page.dart';
import 'package:omohide_map_flutter/views/login/login_page.dart';
import 'package:omohide_map_flutter/views/main/main_page.dart';
import 'package:omohide_map_flutter/views/post/post_page.dart';
import 'package:omohide_map_flutter/views/post_detail/post_detail_page.dart';
import 'package:provider/provider.dart';
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
        return Routes.main;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.main,
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: Routes.post,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => PostViewModel(),
          child: const PostPage(),
        ),
      ),
      GoRoute(
        path: '${Routes.postDetail}/:postId',
        builder: (context, state) => PostDetailPage(
          postId: state.pathParameters['postId']!,
        ),
      ),
    ],
  );
}
