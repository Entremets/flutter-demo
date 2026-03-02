// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/profile_viewmodel.dart';
import '../state/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("个人中心 (ViewModel 版)")),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          final state = viewModel.state;

          // 1. 处理加载状态 (且没有数据时)
          if (state.status == ProfileStatus.loading && state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. 处理错误状态
          if (state.status == ProfileStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text("加载失败: ${state.errorMessage}", textAlign: TextAlign.center),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadProfile(),
                    child: Text("重试"),
                  )
                ],
              ),
            );
          
          
          
          }
          // 3. 处理成功状态 (或有缓存数据)
          final user = state.user;
          if (user == null) {
            return const Center(child: Text("暂无数据"));
          }

          return _buildContent(context, viewModel, user, state.status == ProfileStatus.loading);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileViewModel vm, user, bool isLoading) {
    // 使用 TextEditingController 需要在 Stateful 中管理，或者在这里简单处理
    // 为了演示简洁，这里用一个简单的 StatefulWidget 包裹输入框，或者直接用 TextField 的 onChanged
    // 更好的做法是把 TextEditingController 也放在 ViewModel 里，或者用单独的 StatefulWidget
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("ID", user.id),
          _buildInfoRow("邮箱", user.email),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 10),
          Text("修改昵称", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ProfileForm(user: user, onSave: vm.updateName, isLoading: isLoading),
          if (isLoading) LinearProgressIndicator(),
          if (vm.state.errorMessage != null && !isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(vm.state.errorMessage!, style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

// 提取一个小组件处理输入，避免 ProfilePage 过于复杂
class ProfileForm extends StatefulWidget {
  final user;
  final Function(String) onSave;
  final bool isLoading;
  const ProfileForm({super.key, required this.user, required this.onSave, required this.isLoading});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late TextEditingController _controller;

  @override
  void initState() {
    
    super.initState();
    _controller = TextEditingController(text: widget.user.name);
  
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "新名字", border: OutlineInputBorder()),
            enabled: !widget.isLoading,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: widget.isLoading ? null : () => widget.onSave(_controller.text),
          child: Text("保存"),
        )
      ],
    );
  
  }
}