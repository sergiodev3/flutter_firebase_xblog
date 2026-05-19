// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream en tiempo real de posts — solo para lectura.
///
/// Se mantiene separado de [PostsViewModel] por el principio de
/// responsabilidad única: reads (stream) no deben mezclarse con writes (CRUD).
/// La FeedScreen escucha este provider; cuando Firestore actualiza datos,
/// Riverpod reconstruye automáticamente la UI.

@ProviderFor(postsStream)
final postsStreamProvider = PostsStreamProvider._();

/// Stream en tiempo real de posts — solo para lectura.
///
/// Se mantiene separado de [PostsViewModel] por el principio de
/// responsabilidad única: reads (stream) no deben mezclarse con writes (CRUD).
/// La FeedScreen escucha este provider; cuando Firestore actualiza datos,
/// Riverpod reconstruye automáticamente la UI.

final class PostsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PostEntity>>,
          List<PostEntity>,
          Stream<List<PostEntity>>
        >
    with $FutureModifier<List<PostEntity>>, $StreamProvider<List<PostEntity>> {
  /// Stream en tiempo real de posts — solo para lectura.
  ///
  /// Se mantiene separado de [PostsViewModel] por el principio de
  /// responsabilidad única: reads (stream) no deben mezclarse con writes (CRUD).
  /// La FeedScreen escucha este provider; cuando Firestore actualiza datos,
  /// Riverpod reconstruye automáticamente la UI.
  PostsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<PostEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PostEntity>> create(Ref ref) {
    return postsStream(ref);
  }
}

String _$postsStreamHash() => r'641994b9995364ce73e678f672535e11ebfecaf1';

/// ViewModel para operaciones de escritura en posts (Create, Update, Delete).
///
/// `AsyncNotifier<void>` porque las mutaciones no retornan datos —
/// solo éxito o error. El estado [AsyncLoading] desactiva el botón de submit
/// en la UI, y [AsyncError] dispara el SnackBar de error.

@ProviderFor(PostsViewModel)
final postsViewModelProvider = PostsViewModelProvider._();

/// ViewModel para operaciones de escritura en posts (Create, Update, Delete).
///
/// `AsyncNotifier<void>` porque las mutaciones no retornan datos —
/// solo éxito o error. El estado [AsyncLoading] desactiva el botón de submit
/// en la UI, y [AsyncError] dispara el SnackBar de error.
final class PostsViewModelProvider
    extends $AsyncNotifierProvider<PostsViewModel, void> {
  /// ViewModel para operaciones de escritura en posts (Create, Update, Delete).
  ///
  /// `AsyncNotifier<void>` porque las mutaciones no retornan datos —
  /// solo éxito o error. El estado [AsyncLoading] desactiva el botón de submit
  /// en la UI, y [AsyncError] dispara el SnackBar de error.
  PostsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsViewModelHash();

  @$internal
  @override
  PostsViewModel create() => PostsViewModel();
}

String _$postsViewModelHash() => r'73ae37357321af859150397b007f8bc9c4030205';

/// ViewModel para operaciones de escritura en posts (Create, Update, Delete).
///
/// `AsyncNotifier<void>` porque las mutaciones no retornan datos —
/// solo éxito o error. El estado [AsyncLoading] desactiva el botón de submit
/// en la UI, y [AsyncError] dispara el SnackBar de error.

abstract class _$PostsViewModel extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
