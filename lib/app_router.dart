import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
import 'features/auth/store/auth_store.dart';
import 'features/auth/ui/sign_in_page.dart';
import 'features/todo/ui/home_page.dart';
import 'features/todo/ui/todo_edit_page.dart';
import 'splash_page.dart';

class AppRouter {
  final AuthStore auth;
  late final GoRouter router;

  AppRouter(this.auth) {
    router = GoRouter(
      refreshListenable: auth,
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashPage()),
        GoRoute(path: '/signin', builder: (_, __) => const SignInPage()),
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        GoRoute(
          path: '/todo/:id',
          builder: (_, state) => TodoEditPage(id: state.pathParameters['id']!),
        ),
      ],
      redirect: (ctx, state) {
        final loggedIn = auth.current != null;
        final loggingIn = state.matchedLocation == '/signin';
        if (!loggedIn && !loggingIn) return '/signin';
        if (loggedIn && loggingIn) return '/home';
        return null;
      },
    );
  }
}
