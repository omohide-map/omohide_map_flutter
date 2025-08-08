import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:omohide_map_flutter/views/home/home_page.dart';
import 'package:omohide_map_flutter/views/post/post_page.dart';
import 'package:omohide_map_flutter/views/post/post_view_model.dart';
import 'package:omohide_map_flutter/views/posts_list/posts_list_page.dart';
import 'package:omohide_map_flutter/views/settings/settings_page.dart';
import 'package:provider/provider.dart';

class MainPage extends HookWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(initialIndex);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex.value,
        children: [
          const HomePage(),
          ChangeNotifierProvider(
            create: (_) => PostViewModel(),
            child: const PostPage(),
          ),
          const PostsListPage(),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex.value,
        onTap: (index) {
          selectedIndex.value = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '投稿',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '投稿一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
