import 'package:efrei_todo/features/auth/services/auth_service_adapter.dart';
import 'package:efrei_todo/features/auth/store/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'src/screens/home.dart';
import 'src/screens/reset_password.dart';
import 'src/screens/settings.dart';
import 'src/screens/sign_in.dart';
import 'src/screens/sign_up.dart';
import 'src/screens/todo_form.dart';
import 'src/services/firebase/firebase_auth_service.dart';
import 'src/services/firebase/firebase_todo_repository.dart';
import 'src/services/interfaces/auth_service.dart';
import 'src/services/interfaces/todo_repository.dart';
import 'src/stores/theme_store.dart';
import 'src/stores/todo_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const testEmail = 'todo-test@efrei.fr';
  const testPassword = 'test1234';
  final AuthService authService = FirebaseAuthService();
  try {
    await authService.ensureTestUser(email: testEmail, password: testPassword);
  } on FirebaseAuthException catch (e, stack) {
    debugPrint('Skipping default Firebase user bootstrap (${e.code}): ${e.message}');
    debugPrintStack(stackTrace: stack);
  } catch (e, stack) {
    debugPrint('Skipping default Firebase user bootstrap: $e');
    debugPrintStack(stackTrace: stack);
  }
  final AuthStore authStore = AuthStore(AuthServiceAdapter(authService));
  await authStore.init();
  final TodoRepository todoRepo = FirebaseTodoRepository();
  final TodoStore todoStore = TodoStore(todoRepo, authStore);
  await todoStore.init();
  final themeStore = ThemeStore();
  await themeStore.init();
  final router = GoRouter(
    initialLocation: '/',
    refreshListenable: authStore,
    routes: [
      GoRoute(path: '/', builder: (context, state) => const _Splash()),
      GoRoute(path: '/signin', builder: (context, state) => const SignInScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/reset', builder: (context, state) => const ResetPasswordScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/todo/new', builder: (context, state) => const TodoFormScreen()),
      GoRoute(path: '/todo/:id', builder: (context, state) => TodoFormScreen(id: state.pathParameters['id'])),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    ],
    redirect: (context, state) {
      final loggedIn = authStore.currentUserEmail != null;
      final goingToAuth = state.fullPath == '/signin' || state.fullPath == '/signup' || state.fullPath == '/reset';
      if (!loggedIn && !goingToAuth && state.fullPath != '/') return '/signin';
      if (loggedIn && goingToAuth) return '/home';
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

  const _App({required this.router});

  @override
  Widget build(BuildContext context) {
    final themeStore = context.watch<ThemeStore>();

    final colorSchemeLight = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
    );

    final colorSchemeDark = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
    );

    ThemeData buildLightTheme() {
      final colorScheme = colorSchemeLight;

      return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha:0.05),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          titleTextStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black.withValues(alpha:0.05),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          fillColor: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return colorScheme.primary;
              }
              return Colors.transparent;
            },
          ),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: colorScheme.primary, width: 2),
        ),
        listTileTheme: ListTileThemeData(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          iconColor: colorScheme.primary,
          textColor: Colors.black87,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          subtitleTextStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    ThemeData buildDarkTheme() {
      return ThemeData(
        useMaterial3: true,
        colorScheme: colorSchemeDark,
      );
    }

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeStore.mode,
    );
  }
}

class _Splash extends StatefulWidget {
  const _Splash();

  @override
  State<_Splash> createState() => _SplashState();
}

class _SplashState extends State<_Splash> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final email = context.read<AuthStore>().currentUserEmail;
      context.go(email == null ? '/signin' : '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
