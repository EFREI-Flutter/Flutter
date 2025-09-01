import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'src/stores/auth_store.dart';
import 'src/stores/todo_store.dart';
import 'src/stores/theme_store.dart';
import 'src/screens/sign_in.dart';
import 'src/screens/sign_up.dart';
import 'src/screens/reset_password.dart';
import 'src/screens/home.dart';
import 'src/screens/todo_form.dart';
import 'src/screens/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authStore = AuthStore();
  await authStore.init();
  final todoStore = TodoStore(authStore);
  await todoStore.init();
  final themeStore = ThemeStore();
  await themeStore.init();
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: authStore,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _Splash(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/reset',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/todo/new',
        builder: (context, state) => const TodoFormScreen(),
      ),
      GoRoute(
        path: '/todo/:id',
        builder: (context, state) => TodoFormScreen(id: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) {
      final loggedIn = authStore.currentUserEmail != null;
      final goingToAuth = state.fullPath == '/signin' || state.fullPath == '/signup' || state.fullPath == '/reset';
      if (!loggedIn && state.fullPath != '/signin' && state.fullPath != '/signup' && state.fullPath != '/reset') {
        return '/signin';
      }
      if (loggedIn && goingToAuth) {
        return '/home';
      }
      return null;
    },
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: authStore),
      ChangeNotifierProvider.value(value: todoStore),
      ChangeNotifierProvider.value(value: themeStore),
    ],
    child: _App(router: router),
  ));
}

class _App extends StatelessWidget {
  final GoRouter router;
  const _App({required this.router, super.key});
  @override
  Widget build(BuildContext context) {
    final themeStore = context.watch<ThemeStore>();
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: themeStore.mode,
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash({super.key});
  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      final email = context.read<AuthStore>().currentUserEmail;
      context.go(email == null ? '/signin' : '/home');
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
