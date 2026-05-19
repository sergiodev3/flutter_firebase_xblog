// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// GoRouter expuesto como provider de Riverpod.
///
/// Al ser un provider, puede observar el estado de auth directamente
/// sin necesidad de variables globales ni contexto de Build.
/// El `refreshListenable` conecta el stream de Firebase Auth con el router:
/// cada cambio de sesión dispara la función `redirect` automáticamente.

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// GoRouter expuesto como provider de Riverpod.
///
/// Al ser un provider, puede observar el estado de auth directamente
/// sin necesidad de variables globales ni contexto de Build.
/// El `refreshListenable` conecta el stream de Firebase Auth con el router:
/// cada cambio de sesión dispara la función `redirect` automáticamente.

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// GoRouter expuesto como provider de Riverpod.
  ///
  /// Al ser un provider, puede observar el estado de auth directamente
  /// sin necesidad de variables globales ni contexto de Build.
  /// El `refreshListenable` conecta el stream de Firebase Auth con el router:
  /// cada cambio de sesión dispara la función `redirect` automáticamente.
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'7cd66cdd4685edaf06434f5ced66e64a27d803ef';
