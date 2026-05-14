// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postsStreamHash() => r'641994b9995364ce73e678f672535e11ebfecaf1';

/// Stream en tiempo real de posts — solo para lectura.
///
/// Se mantiene separado de [PostsViewModel] por el principio de
/// responsabilidad única: reads (stream) no deben mezclarse con writes (CRUD).
/// La FeedScreen escucha este provider; cuando Firestore actualiza datos,
/// Riverpod reconstruye automáticamente la UI.
///
/// Copied from [postsStream].
@ProviderFor(postsStream)
final postsStreamProvider =
    AutoDisposeStreamProvider<List<PostEntity>>.internal(
      postsStream,
      name: r'postsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$postsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PostsStreamRef = AutoDisposeStreamProviderRef<List<PostEntity>>;
String _$postsViewModelHash() => r'73ae37357321af859150397b007f8bc9c4030205';

/// ViewModel para operaciones de escritura en posts (Create, Update, Delete).
///
/// `AsyncNotifier<void>` porque las mutaciones no retornan datos —
/// solo éxito o error. El estado [AsyncLoading] desactiva el botón de submit
/// en la UI, y [AsyncError] dispara el SnackBar de error.
///
/// Copied from [PostsViewModel].
@ProviderFor(PostsViewModel)
final postsViewModelProvider =
    AutoDisposeAsyncNotifierProvider<PostsViewModel, void>.internal(
      PostsViewModel.new,
      name: r'postsViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$postsViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PostsViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
