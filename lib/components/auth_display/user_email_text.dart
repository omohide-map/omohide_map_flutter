import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserEmailText extends StatelessWidget {
  final TextStyle? style;
  final String defaultText;
  final int? maxLines;
  final TextOverflow? overflow;

  const UserEmailText({
    super.key,
    this.style,
    this.defaultText = 'Unknown User',
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final theme = Theme.of(context);

    return Text(
      user?.email ?? defaultText,
      style: style ?? theme.textTheme.bodyLarge,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}