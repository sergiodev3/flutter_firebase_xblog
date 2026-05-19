// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream del estado de autenticación de Firebase.
///
/// Es un StreamProvider separado del AuthViewModel porque:
/// 1. GoRouter lo observa para redirigir rutas automáticamente
/// 2. Otros providers pueden escucharlo sin acoplarse al ViewModel completo

@ProviderFor(authStateChanges)
final authStateChangesProvider = AuthStateChangesProvider._();

/// Stream del estado de autenticación de Firebase.
///
/// Es un StreamProvider separado del AuthViewModel porque:
/// 1. GoRouter lo observa para redirigir rutas automáticamente
/// 2. Otros providers pueden escucharlo sin acoplarse al ViewModel completo

final class AuthStateChangesProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserEntity?>,
          UserEntity?,
          Stream<UserEntity?>
        >
    with $FutureModifier<UserEntity?>, $StreamProvider<UserEntity?> {
  /// Stream del estado de autenticación de Firebase.
  ///
  /// Es un StreamProvider separado del AuthViewModel porque:
  /// 1. GoRouter lo observa para redirigir rutas automáticamente
  /// 2. Otros providers pueden escucharlo sin acoplarse al ViewModel completo
  AuthStateChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateChangesHash();

  @$internal
  @override
  $StreamProviderElement<UserEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<UserEntity?> create(Ref ref) {
    return authStateChanges(ref);
  }
}

String _$authStateChangesHash() => r'63852778998160fd4cc47065617b58b690073124';

/// ViewModel de autenticación — `AsyncNotifier` de `UserEntity?`.
///
/// En MVVM, el ViewModel expone el estado y los comandos (métodos) que la
/// pantalla puede invocar. La UI nunca toca el repositorio directamente.

@ProviderFor(AuthViewModel)
final authViewModelProvider = AuthViewModelProvider._();

/// ViewModel de autenticación — `AsyncNotifier` de `UserEntity?`.
///
/// En MVVM, el ViewModel expone el estado y los comandos (métodos) que la
/// pantalla puede invocar. La UI nunca toca el repositorio directamente.
final class AuthViewModelProvider
    extends $AsyncNotifierProvider<AuthViewModel, UserEntity?> {
  /// ViewModel de autenticación — `AsyncNotifier` de `UserEntity?`.
  ///
  /// En MVVM, el ViewModel expone el estado y los comandos (métodos) que la
  /// pantalla puede invocar. La UI nunca toca el repositorio directamente.
  AuthViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewModelHash();

  @$internal
  @override
  AuthViewModel create() => AuthViewModel();
}

String _$authViewModelHash() => r'32260500639e3d709694ba71211367738efd813e';

/// ViewModel de autenticación — `AsyncNotifier` de `UserEntity?`.
///
/// En MVVM, el ViewModel expone el estado y los comandos (métodos) que la
/// pantalla puede invocar. La UI nunca toca el repositorio directamente.

abstract class _$AuthViewModel extends $AsyncNotifier<UserEntity?> {
  FutureOr<UserEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserEntity?>, UserEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserEntity?>, UserEntity?>,
              AsyncValue<UserEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
