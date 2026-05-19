// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider de Riverpod para inyectar el repositorio de auth.
/// Al declararlo aquí, el ViewModel no necesita conocer Firebase directamente.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Provider de Riverpod para inyectar el repositorio de auth.
/// Al declararlo aquí, el ViewModel no necesita conocer Firebase directamente.

final class AuthRepositoryProvider
    extends
        $FunctionalProvider<IAuthRepository, IAuthRepository, IAuthRepository>
    with $Provider<IAuthRepository> {
  /// Provider de Riverpod para inyectar el repositorio de auth.
  /// Al declararlo aquí, el ViewModel no necesita conocer Firebase directamente.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<IAuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IAuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IAuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'dd72fc2a5a3e5e81b8e0ee3829125513c55b5f2b';
