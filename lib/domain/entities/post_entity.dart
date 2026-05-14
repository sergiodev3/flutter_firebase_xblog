/// Entidad de post — objeto de negocio puro, sin dependencias externas.
class PostEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Regla de negocio: verifica si el post pertenece a un usuario dado.
  /// Esta lógica vive en la entidad, no en la UI, para que sea reutilizable
  /// desde cualquier capa sin duplicar la comparación de IDs.
  bool isOwnedBy(String userId) => authorId == userId;

  PostEntity copyWith({
    String? content,
    String? imageUrl,
    DateTime? updatedAt,
  }) =>
      PostEntity(
        id: id,
        authorId: authorId,
        authorName: authorName,
        authorPhotoUrl: authorPhotoUrl,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is PostEntity && id == other.id);

  @override
  int get hashCode => id.hashCode;
}
