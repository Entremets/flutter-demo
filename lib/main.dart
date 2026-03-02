import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_preferences/shared_preferences.dart';
// Import Data & Domain (Profile)
import 'features/profile/data/datasources/profile_local_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_user_profile.dart';
import 'features/profile/domain/usecases/update_user_name.dart';

// Import Presentation

import 'features/profile/persentation/viewmodels/profile_viewmodel.dart';
import 'features/profile/persentation/pages/profile_page.dart';

// Import New Home Feature
import 'features/home/presentation/pages/home_page.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
// Import Shell
import 'core/widgets/main_shell.dart';
import 'core/auth/auth_notifier.dart';
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  final sharedPreferences = await SharedPreferences.getInstance();

  final authNotifier = AuthNotifier();
  final secureStorage = SecureStorageService();


  final dioClient = DioClient(
    baseUrl: 'https://api.example.com', // 🔥 替换为你的真实 API 地址
    authNotifier: authNotifier,
    secureStorage: secureStorage
  );
  

  
  
  final localDataSource = ProfileLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  final remoteDataSource = ProfileRemoteDataSourceImpl(dioClient: dioClient);
  final ProfileRepository repository = ProfileRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource, // 注入远程数据源
    authNotifier: authNotifier, // 注入认证管理器
  );
  
  final getUserProfile = GetUserProfile(repository);
  final updateUserName = UpdateUserName(repository);

  // 3. 启动 App
  runApp(
    MultiProvider(
      providers: [
        // Profile ViewModel
        ChangeNotifierProvider(
         
          create: (_) => ProfileViewModel(
            
            getUserProfile: getUserProfile,
            updateUserName: updateUserName,
          )..loadProfile(),
        ),
        // 如果有 HomeViewModel，在这里添加
        // ChangeNotifierProvider(create: (_) => HomeViewModel(...)..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 配置 GoRouter
    
    
    final GoRouter router = GoRouter(
      initialLocation: '/home', // 默认进入首页
      routes: [
        // 根路由，负责渲染底部导航栏外壳
        GoRoute(
          path: '/',
          redirect: (_, __) => '/home', // 访问 / 时自动重定向到 /home
        ),
        // 使用 ShellRoute 或者简单的子路由来管理带导航的布局
        // 这里为了简单，我们定义两个顶级路由，但它们在 UI 上共享同一个 Scaffold (通过 MainShell 实现有点复杂)
        // 【更优方案】：使用 GoRouter 的 ShellRoute (推荐) 或者 手动管理
        
        // 方案 A: 简单粗暴法 (每个路由自己画 Scaffold) - 不推荐，导航栏会闪烁
        // 方案 B: ShellRoute (官方推荐，状态保持好)
        ShellRoute(
          builder: (context, state, child) {
            // child 就是当前选中的页面 (HomePage 或 ProfilePage)
            return MainShell(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
            ),
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => const NoTransitionPage(child: ProfilePage()),
            ),
          ],
        ),
      ],
    
    );

    return MaterialApp.router(
      title: 'Clean Architecture Demo',
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}