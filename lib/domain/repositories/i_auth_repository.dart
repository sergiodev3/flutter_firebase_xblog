import 'package:community_wall/domain/entities/user_entity.dart';

/// Interfaz del repositorio de autenticación.
///
/// Define el "contrato" que cualquier implementación (Firebase, Supabase,
/// mock para tests) debe cumplir. El ViewModel solo depende de esta interfaz,
/// lo que permite intercambiar el backend sin tocar la lógica de presentación.
abstract interface class IAuthRepository {
  /// Stream que emite el usuario actual cuando cambia el estado de auth.
  /// Emite `null` cuando no hay sesión activa.
  Stream<UserEntity?> get authStateChanges;

  /// Usuario actualmente autenticado, o `null` si no hay sesión.
  UserEntity? get currentUser;

  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  Future<UserEntity> register({
    required String displayName,
    required String email,
    required String password,
  });

  Future<void> signOut();
}
