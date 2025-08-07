import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omohide_map_flutter/components/auth_display/user_info_card.dart';
import 'package:omohide_map_flutter/components/logout_buttons/logout_icon_button.dart';
import 'package:omohide_map_flutter/constants/routes.dart';
import 'package:omohide_map_flutter/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('おもひでまっぷ'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            const LogoutIconButton(),
          ],
        ),
        body: Center(
          child: _HomePageBody(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(Routes.post),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  const _HomePageBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const UserInfoCard(showLogoutButton: false),
        const SizedBox(height: 20),
        if (viewModel.data != null) Text(viewModel.data!),
        ElevatedButton(
          onPressed: () => viewModel.getHealthCheck(),
          child: const Text('health check'),
        ),
      ],
    );
  }
}
