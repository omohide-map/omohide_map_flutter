import 'package:flutter/material.dart';
import 'package:omohide_map_flutter/components/auth_display/user_info_card.dart';
import 'package:omohide_map_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const UserInfoCard(showLogoutButton: true),
        const SizedBox(height: 24),
        _SettingsSection(
          title: 'テーマ設定',
          children: [
            _ThemeSelector(),
          ],
        ),
        const SizedBox(height: 24),
        _SettingsSection(
          title: 'アプリ情報',
          children: [
            _SettingsTile(
              icon: Icons.info,
              title: 'バージョン',
              subtitle: '1.0.0',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.description,
              title: 'ライセンス',
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return _SettingsTile(
      icon: Icons.palette,
      title: 'テーマ',
      subtitle: _getThemeModeText(themeProvider.themeMode),
      trailing: DropdownButton<ThemeMode>(
        value: themeProvider.themeMode,
        onChanged: (ThemeMode? newMode) {
          if (newMode != null) {
            themeProvider.setThemeMode(newMode);
          }
        },
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text('システム'),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text('ライト'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text('ダーク'),
          ),
        ],
      ),
      onTap: null,
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'システム';
      case ThemeMode.light:
        return 'ライト';
      case ThemeMode.dark:
        return 'ダーク';
    }
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}