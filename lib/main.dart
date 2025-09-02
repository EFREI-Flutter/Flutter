import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'features/auth/services/i_auth_service.dart';
import 'features/auth/services/auth_service_fake.dart';
import 'features/auth/store/auth_store.dart';
import 'features/todo/services/i_todo_repository.dart';
import 'features/todo/services/todo_repository_fake.dart';
import 'features/todo/store/todo_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IAuthService>(create: (_) => AuthServiceFake()),
        Provider<ITodoRepository>(create: (_) => TodoRepositoryFake()),
        ChangeNotifierProvider(create: (ctx) => AuthStore(ctx.read<IAuthService>())),
        ChangeNotifierProvider(create: (ctx) => TodoStore(ctx.read<ITodoRepository>(), ctx.read<AuthStore>())),
        Provider<AppRouter>(create: (ctx) => AppRouter(ctx.read<AuthStore>())),
      ],
      child: Builder(
        builder: (ctx) => MaterialApp.router(
          title: 'EFREI Todo',
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
          routerConfig: ctx.read<AppRouter>().router,
        ),
      ),
    );
  }
}
