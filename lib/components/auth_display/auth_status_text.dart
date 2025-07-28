import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthStatusText extends StatelessWidget {
  final TextStyle? loggedInStyle;
  final TextStyle? loggedOutStyle;
  final String loggedInText;
  final String loggedOutText;

  const AuthStatusText({
    super.key,
    this.loggedInStyle,
    this.loggedOutStyle,
    this.loggedInText = 'ログイン中',
    this.loggedOutText = '未ログイン',
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    if (authProvider.isLoggedIn) {
      return Text(
        loggedInText,
        style: loggedInStyle ??
            theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
      );
    } else {
      return Text(
        loggedOutText,
        style: loggedOutStyle ??
            theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
      );
    }
  }
}
