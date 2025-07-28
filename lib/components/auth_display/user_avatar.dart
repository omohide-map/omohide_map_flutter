import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const UserAvatar({
    super.key,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
      child: user != null
          ? _buildUserIcon(user.email)
          : Icon(
              Icons.person_outline,
              size: size * 0.6,
              color: iconColor ?? theme.colorScheme.onSurfaceVariant,
            ),
    );
  }

  Widget _buildUserIcon(String? email) {
    if (email == null || email.isEmpty) {
      return Icon(
        Icons.person,
        size: size * 0.6,
        color: iconColor ?? Colors.white,
      );
    }

    // メールアドレスの最初の文字を表示
    final initial = email.substring(0, 1).toUpperCase();
    return Text(
      initial,
      style: TextStyle(
        fontSize: size * 0.4,
        fontWeight: FontWeight.bold,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}