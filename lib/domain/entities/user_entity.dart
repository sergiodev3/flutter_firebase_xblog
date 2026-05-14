/// Entidad de usuario — objeto de negocio puro, sin dependencias externas.
///
/// Las entidades de la capa Domain representan el "qué" de la app,
/// independientemente de cómo se almacena (Firebase, Supabase, etc.)
class UserEntity {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  const UserEntity({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });

  /// Obtiene la inicial del nombre para mostrar en avatares sin foto
  String get initial =>
      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is UserEntity && uid == other.uid);

  @override
  int get hashCode => uid.hashCode;
}
