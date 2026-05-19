import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:community_wall/core/constants/app_constants.dart';
import 'package:community_wall/core/errors/app_exception.dart';
import 'package:community_wall/data/models/user_model.dart';
import 'package:community_wall/domain/entities/user_entity.dart';
import 'package:community_wall/domain/repositories/i_auth_repository.dart';

part 'firebase_auth_repository.g.dart';

/// Provider de Riverpod para inyectar el repositorio de auth.
/// Al declararlo aquí, el ViewModel no necesita conocer Firebase directamente.
@riverpod
IAuthRepository authRepository(Ref ref) =>
    FirebaseAuthRepository(
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
    );

/// Implementación concreta de [IAuthRepository] usando Firebase Auth.
///
/// Patrón de diseño aplicado: Repository + Adapter.
/// Esta clase "adapta" la API de Firebase al contrato de [IAuthRepository],
/// aislando al resto de la app de los detalles de Firebase.
class FirebaseAuthRepository implements IAuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  FirebaseAuthRepository(this._auth, this._db);

  @override
  Stream<UserEntity?> get authStateChanges =>
      _auth.authStateChanges().asyncMap((user) async {
        if (user == null) return null;
        // Intentamos cargar el perfil extendido desde Firestore.
        // Si aún no existe (primer login), usamos solo los datos de Auth.
        try {
          final doc = await _db
              .collection(AppConstants.usersCollection)
              .doc(user.uid)
              .get();
          if (doc.exists) return UserModel.fromFirestore(doc).toEntity();
        } catch (_) {
          // Si falla Firestore, fallback a datos de Auth
        }
        return UserModel.fromFirebaseUser(user).toEntity();
      });

  @override
  UserEntity? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user).toEntity();
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return UserModel.fromFirebaseUser(credential.user!).toEntity();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code), code: e.code);
    }
  }

  @override
  Future<UserEntity> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;

      // Actualizamos el displayName en Firebase Auth
      await user.updateDisplayName(displayName.trim());
      await user.reload();

      // Creamos el documento de perfil en Firestore para datos extendidos
      final model = UserModel(
        uid: user.uid,
        displayName: displayName.trim(),
        email: email.trim(),
        createdAt: DateTime.now(),
      );
      await _db
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(model.toJson());

      return model.toEntity();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapAuthError(e.code), code: e.code);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  /// Traduce los códigos de error de Firebase a mensajes comprensibles.
  String _mapAuthError(String code) => switch (code) {
        'user-not-found' => 'No existe una cuenta con ese correo.',
        'wrong-password' => 'Contraseña incorrecta.',
        'invalid-credential' => 'Correo o contraseña incorrectos.',
        'email-already-in-use' => 'Ese correo ya está registrado.',
        'weak-password' => 'La contraseña debe tener al menos 6 caracteres.',
        'invalid-email' => 'El formato del correo no es válido.',
        'user-disabled' => 'Esta cuenta ha sido deshabilitada.',
        'too-many-requests' =>
          'Demasiados intentos fallidos. Intenta más tarde.',
        _ => 'Error de autenticación. Por favor intenta de nuevo.',
      };
}
