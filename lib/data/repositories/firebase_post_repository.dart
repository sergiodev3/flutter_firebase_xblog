import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:community_wall/core/constants/app_constants.dart';
import 'package:community_wall/core/errors/app_exception.dart';
import 'package:community_wall/data/models/post_model.dart';
import 'package:community_wall/data/repositories/firebase_auth_repository.dart';
import 'package:community_wall/domain/entities/post_entity.dart';
import 'package:community_wall/domain/repositories/i_auth_repository.dart';
import 'package:community_wall/domain/repositories/i_post_repository.dart';

part 'firebase_post_repository.g.dart';

@riverpod
IPostRepository postRepository(Ref ref) =>
    FirebasePostRepository(
      FirebaseFirestore.instance,
      FirebaseStorage.instance,
      ref.watch(authRepositoryProvider),
    );

/// Implementación de [IPostRepository] usando Firestore y Firebase Storage.
class FirebasePostRepository implements IPostRepository {
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;
  final IAuthRepository _authRepo;

  FirebasePostRepository(this._db, this._storage, this._authRepo);

  @override
  Stream<List<PostEntity>> watchPosts() {
    // El stream de Firestore emite automáticamente cuando hay cambios —
    // esto es lo que hace el feed "en tiempo real" sin polling.
    return _db
        .collection(AppConstants.postsCollection)
        .orderBy(AppConstants.fieldCreatedAt, descending: true)
        .limit(AppConstants.postsPageSize)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(PostModel.fromFirestore)
              .map((m) => m.toEntity())
              .toList(),
        );
  }

  @override
  Future<PostEntity> createPost({
    required String content,
    String? imagePath,
  }) async {
    final user = _authRepo.currentUser;
    if (user == null) throw const AuthException('Debes iniciar sesión.');

    try {
      String? imageUrl;
      if (imagePath != null && imagePath.isNotEmpty) {
        imageUrl = await uploadPostImage(
          userId: user.uid,
          localPath: imagePath,
        );
      }

      // Generamos el ID antes de set() para poder incluirlo en el modelo
      final ref = _db.collection(AppConstants.postsCollection).doc();
      final now = DateTime.now();
      final model = PostModel(
        id: ref.id,
        authorId: user.uid,
        authorName: user.displayName,
        authorPhotoUrl: user.photoUrl,
        content: content,
        imageUrl: imageUrl,
        createdAt: now,
        updatedAt: now,
      );
      await ref.set(model.toFirestoreCreate());
      return model.toEntity();
    } on StorageException {
      rethrow;
    } catch (e) {
      throw PostException('No se pudo publicar el mensaje: $e');
    }
  }

  @override
  Future<void> updatePost({
    required String postId,
    required String content,
    String? imagePath,
  }) async {
    final user = _authRepo.currentUser;
    if (user == null) throw const AuthException('Debes iniciar sesión.');

    try {
      String? imageUrl;
      if (imagePath != null && imagePath.isNotEmpty) {
        imageUrl = await uploadPostImage(
          userId: user.uid,
          localPath: imagePath,
        );
      }

      final updates = PostModel(
        id: postId,
        authorId: user.uid,
        authorName: user.displayName,
        content: content,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ).toFirestoreUpdate();

      // Si imagePath es cadena vacía, el usuario quiere eliminar la imagen
      if (imagePath == '') updates['imageUrl'] = null;

      await _db
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .update(updates);
    } catch (e) {
      throw PostException('No se pudo actualizar el mensaje: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      // Obtenemos el post para saber si tiene imagen que borrar del Storage
      final doc = await _db
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .get();

      if (doc.exists) {
        final imageUrl = doc.data()?['imageUrl'] as String?;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          await _deleteImageFromUrl(imageUrl);
        }
      }

      await _db
          .collection(AppConstants.postsCollection)
          .doc(postId)
          .delete();
    } catch (e) {
      throw PostException('No se pudo eliminar el mensaje: $e');
    }
  }

  @override
  Future<String?> uploadPostImage({
    required String userId,
    required String localPath,
  }) async {
    try {
      final file = File(localPath);
      final extension = localPath.split('.').last.toLowerCase();
      final filename = '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final ref = _storage.ref(
        '${AppConstants.postImagesPath}/$userId/$filename',
      );

      await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/$extension'),
      );
      return await ref.getDownloadURL();
    } catch (e) {
      throw StorageException('No se pudo subir la imagen: $e');
    }
  }

  Future<void> _deleteImageFromUrl(String url) async {
    try {
      await _storage.refFromURL(url).delete();
    } catch (_) {
      // Si falla el borrado de Storage no bloqueamos el borrado del post
    }
  }
}
