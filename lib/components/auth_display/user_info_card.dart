import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/components/auth_display/auth_status_text.dart';
import 'package:omohide_map_flutter/components/auth_display/user_avatar.dart';
import 'package:omohide_map_flutter/components/auth_display/user_email_text.dart';
import 'package:omohide_map_flutter/components/logout_buttons/logout_button.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserInfoCard extends StatelessWidget {
  final bool showLogoutButton;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const UserInfoCard({
    super.key,
    this.showLogoutButton = true,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    if (user == null) {
      return Card(
        margin: margin ?? const EdgeInsets.all(20),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const UserAvatar(size: 80),
              const SizedBox(height: 16),
              const AuthStatusText(),
              const SizedBox(height: 8),
              Text(
                'ログインしてください',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: margin ?? const EdgeInsets.all(20),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const UserAvatar(size: 80),
            const SizedBox(height: 16),
            const AuthStatusText(),
            const SizedBox(height: 8),
            const UserEmailText(),
            if (showLogoutButton) ...[
              const SizedBox(height: 20),
              const LogoutButton(),
            ],
          ],
        ),
      ),
    );
  }
}