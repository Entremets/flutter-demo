import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 设置页面
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 示例：设置项的状态变量
  bool _notificationsEnabled = true; // 通知开关
  String _selectedTheme = '浅色模式'; // 选中的主题
  final List<String> _themeOptions = ['浅色模式', '深色模式', '跟随系统']; // 主题选项

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 顶部导航栏
      appBar: AppBar(
        title: const Text('设置'),
        // 左侧返回按钮（也可以用系统默认，这里自定义样式）
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            // 返回上一页
            context.pop();
          },
        ),
        // 右侧操作按钮（示例：保存设置）
        actions: [
          TextButton(
            onPressed: () {
              // 模拟保存设置
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('设置已保存')),
              );
            },
            child: const Text(
              '保存',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),

      // 页面主体内容
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          // 1. 通知设置项（开关）
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: const Text('开启消息通知'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),

          // 分割线
          const Divider(height: 1, indent: 16, endIndent: 16),

          // 2. 主题设置项（下拉选择）
          ListTile(
            leading: const Icon(Icons.color_lens, color: Colors.blue),
            title: const Text('主题设置'),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              underline: const SizedBox(), // 隐藏下划线
              items: _themeOptions
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTheme = newValue;
                  });
                }
              },
            ),
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // 3. 关于我们（点击跳转示例）
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: const Text('关于我们'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // 模拟跳转到关于页面（这里可以扩展新路由）
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('关于'),
                  content: const Text('Flutter路由示例 v1.0\n基于go_router实现'),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('确定'),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // 4. 退出登录（示例按钮）
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              '退出登录',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // 模拟退出登录，返回首页
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('确认退出？'),
                  content: const Text('退出后将返回首页'),
                  actions: [
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        // 关闭弹窗，然后跳转到首页（替换路由栈）
                        context.pop();
                        context.goNamed('home');
                      },
                      child: const Text('确认'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}