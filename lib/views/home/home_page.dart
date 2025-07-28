import 'package:flutter/material.dart';
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
          actions: [],
        ),
        body: Center(
          child: _HomePageBody(),
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
    return Text(viewModel.data ?? '');
  }
}
