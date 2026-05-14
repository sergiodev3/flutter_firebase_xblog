import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centraliza la lectura de variables de entorno del archivo .env.
///
/// Uso: asegúrate de llamar `await dotenv.load()` en main() antes de
/// acceder a cualquier getter de esta clase.
abstract final class Env {
  static String get apiKey => _require('FIREBASE_API_KEY');
  static String get appId => _require('FIREBASE_APP_ID');
  static String get messagingSenderId => _require('FIREBASE_MESSAGING_SENDER_ID');
  static String get projectId => _require('FIREBASE_PROJECT_ID');
  static String get storageBucket => _require('FIREBASE_STORAGE_BUCKET');
  static String get authDomain => _require('FIREBASE_AUTH_DOMAIN');

  /// Construye las opciones de Firebase a partir de las variables de entorno.
  /// Permite cambiar el entorno (dev/prod) sin tocar el código fuente.
  static FirebaseOptions get firebaseOptions => FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        storageBucket: storageBucket,
        authDomain: authDomain,
      );

  static String _require(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError(
        'Variable de entorno "$key" no encontrada. '
        'Verifica que el archivo .env existe y tiene ese campo.',
      );
    }
    return value;
  }
}
