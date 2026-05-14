import 'package:community_wall/domain/entities/post_entity.dart';

/// Interfaz del repositorio de posts.
///
/// El uso de `Stream` en `watchPosts` permite que la UI se actualice
/// automáticamente cuando cambian los datos en Firestore, sin polling manual.
abstract interface class IPostRepository {
  /// Stream de posts ordenados por fecha descendente (más recientes primero).
  /// La UI lo consume con un StreamBuilder o StreamProvider de Riverpod.
  Stream<List<PostEntity>> watchPosts();

  Future<PostEntity> createPost({
    required String content,
    String? imagePath,
  });

  Future<void> updatePost({
    required String postId,
    required String content,
    // null = mantener imagen actual; '' = eliminar imagen
    String? imagePath,
  });

  Future<void> deletePost(String postId);

  /// Sube una imagen al Storage y retorna la URL de descarga.
  Future<String?> uploadPostImage({
    required String userId,
    required String localPath,
  });
}
