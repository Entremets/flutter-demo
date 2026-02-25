import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



/// 详情页面
class DetailPage extends StatelessWidget {
  final String id;
  final String? name;

  // 构造函数接收参数
  const DetailPage({
    super.key,
    
    required this.id,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('详情页'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('路径参数 ID：$id', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text(
              '查询参数 名称：${name ?? '未传递'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }
}