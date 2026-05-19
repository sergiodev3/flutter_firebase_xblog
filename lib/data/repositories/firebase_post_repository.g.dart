// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_post_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(postRepository)
final postRepositoryProvider = PostRepositoryProvider._();

final class PostRepositoryProvider
    extends
        $FunctionalProvider<IPostRepository, IPostRepository, IPostRepository>
    with $Provider<IPostRepository> {
  PostRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postRepositoryHash();

  @$internal
  @override
  $ProviderElement<IPostRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IPostRepository create(Ref ref) {
    return postRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IPostRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IPostRepository>(value),
    );
  }
}

String _$postRepositoryHash() => r'039ccb6e7a66fa1764cffc1c5bddec0f1ba812bb';
