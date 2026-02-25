import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/home_page.dart';
import 'pages/detail_page.dart';
import 'pages/settings_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/detail/:id',
      name: 'detail',
      builder: (BuildContext context, GoRouterState state) {
        // 修复：新版用pathParameters获取路径参数
        final String id = state.pathParameters['id']!;
        // 修复：新版用uri.queryParameters获取查询参数
        final String? name = state.uri.queryParameters['name'];
        
        return DetailPage(id: id, name: name);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsPage();
      },
    ),
  ],
  errorBuilder: (BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('页面不存在')),
      body: const Center(child: Text('404 Not Found')),
    );
  },
);