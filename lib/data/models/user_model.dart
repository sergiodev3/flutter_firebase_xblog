import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:community_wall/domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// Modelo de datos del usuario — capa Data.
///
/// Diferencia clave entre Model y Entity:
/// - Entity: objeto de negocio puro (domain layer), sin deps externas
/// - Model: sabe cómo serializar/deserializar desde la fuente de datos (Firebase)
@JsonSerializable(explicitToJson: true)
class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;

  @JsonKey(fromJson: _timestampToDate, toJson: _dateToTimestamp)
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Construye el modelo desde un DocumentSnapshot de Firestore.
  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      UserModel.fromJson(doc.data()!);

  /// Construye el modelo desde un usuario de Firebase Auth.
  /// Se usa justo después del registro/login, antes de tener el documento en Firestore.
  factory UserModel.fromFirebaseUser(User user) => UserModel(
        uid: user.uid,
        displayName: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        createdAt: DateTime.now(),
      );

  /// Convierte al objeto de dominio (Entity) — elimina la dependencia de Firebase
  /// de las capas superiores (ViewModel, UI).
  UserEntity toEntity() => UserEntity(
        uid: uid,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
        createdAt: createdAt,
      );

  // Conversores para Timestamp de Firestore ↔ DateTime de Dart
  static DateTime _timestampToDate(dynamic ts) =>
      ts is Timestamp ? ts.toDate() : DateTime.now();

  static dynamic _dateToTimestamp(DateTime dt) => Timestamp.fromDate(dt);
}
