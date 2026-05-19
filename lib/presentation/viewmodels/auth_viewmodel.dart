import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:community_wall/data/repositories/firebase_auth_repository.dart';
import 'package:community_wall/domain/entities/user_entity.dart';

part 'auth_viewmodel.g.dart';

/// Stream del estado de autenticación de Firebase.
///
/// Es un StreamProvider separado del AuthViewModel porque:
/// 1. GoRouter lo observa para redirigir rutas automáticamente
/// 2. Otros providers pueden escucharlo sin acoplarse al ViewModel completo
@riverpod
Stream<UserEntity?> authStateChanges(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges;

/// ViewModel de autenticación — `AsyncNotifier` de `UserEntity?`.
///
/// En MVVM, el ViewModel expone el estado y los comandos (métodos) que la
/// pantalla puede invocar. La UI nunca toca el repositorio directamente.
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  Future<UserEntity?> build() async {
    // Escuchamos el stream de cambios de auth y reconstruimos el estado
    // automáticamente cuando el usuario inicia o cierra sesión.
    final sub = ref.listen(authStateChangesProvider, (_, next) {
      state = next;
    });
    ref.onDispose(sub.close);

    return ref.read(authStateChangesProvider).asData?.value;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password),
    );
  }

  Future<void> register(
    String displayName,
    String email,
    String password,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).register(
            displayName: displayName,
            email: email,
            password: password,
          ),
    );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }
}
