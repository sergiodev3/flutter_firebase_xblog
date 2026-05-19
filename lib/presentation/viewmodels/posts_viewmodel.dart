import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:community_wall/data/repositories/firebase_post_repository.dart';
import 'package:community_wall/domain/entities/post_entity.dart';

part 'posts_viewmodel.g.dart';

/// Stream en tiempo real de posts — solo para lectura.
///
/// Se mantiene separado de [PostsViewModel] por el principio de
/// responsabilidad única: reads (stream) no deben mezclarse con writes (CRUD).
/// La FeedScreen escucha este provider; cuando Firestore actualiza datos,
/// Riverpod reconstruye automáticamente la UI.
@riverpod
Stream<List<PostEntity>> postsStream(Ref ref) =>
    ref.watch(postRepositoryProvider).watchPosts();

/// ViewModel para operaciones de escritura en posts (Create, Update, Delete).
///
/// `AsyncNotifier<void>` porque las mutaciones no retornan datos —
/// solo éxito o error. El estado [AsyncLoading] desactiva el botón de submit
/// en la UI, y [AsyncError] dispara el SnackBar de error.
@riverpod
class PostsViewModel extends _$PostsViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> createPost(String content, {String? imagePath}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(postRepositoryProvider).createPost(
            content: content,
            imagePath: imagePath,
          ),
    );
  }

  Future<void> updatePost(
    String postId,
    String content, {
    String? imagePath,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(postRepositoryProvider).updatePost(
            postId: postId,
            content: content,
            imagePath: imagePath,
          ),
    );
  }

  Future<void> deletePost(String postId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(postRepositoryProvider).deletePost(postId),
    );
  }
}
