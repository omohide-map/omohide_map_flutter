import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LogoutTextButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;

  const LogoutTextButton({
    super.key,
    this.text = 'ログアウト',
    this.backgroundColor,
    this.foregroundColor,
    this.iconSize,
    this.padding,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? () => _showLogoutDialog(context),
      icon: Icon(
        Icons.logout,
        size: iconSize,
      ),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.red,
        foregroundColor: foregroundColor ?? Colors.white,
        padding: padding,
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウト確認'),
        content: const Text('本当にログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.signOut();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ログアウトに失敗しました: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}