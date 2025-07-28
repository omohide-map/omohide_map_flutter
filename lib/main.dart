import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'constants/theme.dart';
import 'router.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeViewModel, child) {
          return MaterialApp.router(
            title: 'おもひでまっぷ',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeViewModel.themeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
