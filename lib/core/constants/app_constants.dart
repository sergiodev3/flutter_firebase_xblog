/// Constantes globales de la aplicación.
/// Centralizar los nombres evita errores de typo en las queries de Firestore.
abstract final class AppConstants {
  // ── Colecciones Firestore ──────────────────────────────────────
  static const String usersCollection = 'users';
  static const String postsCollection = 'posts';

  // ── Rutas en Firebase Storage ──────────────────────────────────
  static const String postImagesPath = 'posts';

  // ── Campos Firestore (evita magic strings) ─────────────────────
  static const String fieldAuthorId = 'authorId';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';
  static const String fieldContent = 'content';

  // ── Paginación ─────────────────────────────────────────────────
  static const int postsPageSize = 30;

  // ── Validación ─────────────────────────────────────────────────
  static const int maxPostLength = 500;
  static const int maxDisplayNameLength = 50;
  static const int maxImageSizeMb = 5;
}
