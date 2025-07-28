import 'package:go_router/go_router.dart';
import 'package:omohide_map_flutter/views/home/home_page.dart';
import 'constants/routes.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
