import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:community_wall/presentation/screens/auth/login_screen.dart';
import 'package:community_wall/presentation/screens/auth/register_screen.dart';
import 'package:community_wall/presentation/screens/feed/feed_screen.dart';
import 'package:community_wall/presentation/screens/post/create_edit_post_screen.dart';
import 'package:community_wall/presentation/screens/splash/splash_screen.dart';
import 'package:community_wall/presentation/viewmodels/auth_viewmodel.dart';

part 'app_router.g.dart';

/// Nombres de rutas centralizados — evita errores de typo en context.go('/ruta')
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const feed = '/feed';
  static const createPost = '/post/create';
  static const editPost = '/post/edit';
}

/// GoRouter expuesto como provider de Riverpod.
///
/// Al ser un provider, puede observar el estado de auth directamente
/// sin necesidad de variables globales ni contexto de Build.
/// El `refreshListenable` conecta el stream de Firebase Auth con el router:
/// cada cambio de sesión dispara la función `redirect` automáticamente.
@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    // Usamos el stream nativo de Firebase Auth directamente para evitar la
    // deprecación de .stream en Riverpod 2.6+. Cada cambio de sesión
    // dispara redirect() automáticamente.
    refreshListenable: _GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state) {
      final isAuthenticated = authState.asData?.value != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Sin sesión → solo puede ir a rutas de auth
      if (!isAuthenticated && !isAuthRoute) return AppRoutes.login;
      // Con sesión → no puede volver a splash/login/register
      if (isAuthenticated && isAuthRoute) return AppRoutes.feed;
      return null; // null = permitir la navegación
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (_, s) => _fadePage(const SplashScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (_, s) => _slidePage(const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (_, s) => _slidePage(const RegisterScreen()),
      ),
      GoRoute(
        path: AppRoutes.feed,
        pageBuilder: (_, s) => _fadePage(const FeedScreen()),
      ),
      GoRoute(
        path: AppRoutes.createPost,
        pageBuilder: (_, s) => _slidePage(const CreateEditPostScreen()),
      ),
      GoRoute(
        path: '${AppRoutes.editPost}/:postId',
        pageBuilder: (_, state) => _slidePage(
          CreateEditPostScreen(postId: state.pathParameters['postId']),
        ),
      ),
    ],
  );
}

// ── Helpers de transición de página ───────────────────────────────────────────

CustomTransitionPage<void> _fadePage(Widget child) =>
    CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    );

CustomTransitionPage<void> _slidePage(Widget child) =>
    CustomTransitionPage<void>(
      child: child,
      transitionDuration: const Duration(milliseconds: 350),
      transitionsBuilder: (_, animation, _, child) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );

// ── Helper: convierte un Stream en Listenable para GoRouter ───────────────────

/// GoRouter necesita un [Listenable] para observar cambios externos.
/// Esta clase envuelve un Stream y notifica a los listeners cada vez que
/// el stream emite un valor. Patrón común en apps GoRouter + Riverpod.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
