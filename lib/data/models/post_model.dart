import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:community_wall/domain/entities/post_entity.dart';

part 'post_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPhotoUrl;
  final String content;
  final String? imageUrl;

  @JsonKey(fromJson: _timestampToDate, toJson: _dateToTimestamp)
  final DateTime createdAt;

  @JsonKey(fromJson: _timestampToDate, toJson: _dateToTimestamp)
  final DateTime updatedAt;

  const PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPhotoUrl,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  /// Construye desde un DocumentSnapshot incluyendo el ID del documento como campo.
  factory PostModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = Map<String, dynamic>.from(doc.data()!);
    data['id'] = doc.id; // El ID no está en el documento, solo como metadata
    return PostModel.fromJson(data);
  }

  /// Datos para crear un documento nuevo en Firestore.
  /// Separa campos de creación de campos de actualización para mayor control.
  Map<String, dynamic> toFirestoreCreate() => {
        'authorId': authorId,
        'authorName': authorName,
        'authorPhotoUrl': authorPhotoUrl,
        'content': content,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  /// Datos para actualizar un documento existente.
  /// Solo actualiza campos mutables — nunca toca authorId ni createdAt.
  Map<String, dynamic> toFirestoreUpdate() => {
        'content': content,
        'imageUrl': imageUrl,
        // serverTimestamp() usa el reloj del servidor, más confiable que el del cliente
        'updatedAt': FieldValue.serverTimestamp(),
      };

  PostEntity toEntity() => PostEntity(
        id: id,
        authorId: authorId,
        authorName: authorName,
        authorPhotoUrl: authorPhotoUrl,
        content: content,
        imageUrl: imageUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static DateTime _timestampToDate(dynamic ts) =>
      ts is Timestamp ? ts.toDate() : DateTime.now();

  static dynamic _dateToTimestamp(DateTime dt) => Timestamp.fromDate(dt);
}
