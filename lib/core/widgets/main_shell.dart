// lib/core/widgets/main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatefulWidget {
  final Widget child; // 当前选中的页面内容
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  
  @override
  Widget build(BuildContext context) {
    // 获取当前匹配的路由路径，用于高亮对应的导航项
    final location = GoRouterState.of(context).uri.path;
    
    // 判断当前应该在哪个 tab
    int selectedIndex = 0;
    if (location.startsWith('/home')) selectedIndex = 0;
    else if (location.startsWith('/profile')) selectedIndex = 1;

    return Scaffold(
      body: widget.child, // 显示当前路由对应的页面 (HomePage 或 ProfilePage)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          // 点击导航项，切换路由
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}