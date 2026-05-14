/// Jerarquía de excepciones tipadas para la app.
///
/// Usar `sealed` (Dart 3) permite al compilador exigir que todos los
/// subtipos sean manejados en un switch exhaustivo en la capa UI.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// Errores del módulo de autenticación (login, registro, etc.)
final class AuthException extends AppException {
  /// Código original de FirebaseAuthException para logging/debugging
  final String? code;
  const AuthException(super.message, {this.code});
}

/// Errores al leer, crear, editar o borrar posts
final class PostException extends AppException {
  const PostException(super.message);
}

/// Errores al subir o bajar archivos de Firebase Storage
final class StorageException extends AppException {
  const StorageException(super.message);
}

/// Error de conectividad o timeout
final class NetworkException extends AppException {
  const NetworkException(super.message);
}
