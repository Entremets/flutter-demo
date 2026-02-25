import 'package:flutter/material.dart';
import 'router.dart'; // 导入路由配置

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 核心：配置GoRouter的routerConfig（必须有，无home参数）
      routerConfig: router,
    );
  }
}