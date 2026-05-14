import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:community_wall/core/config/env.dart';
import 'package:community_wall/core/router/app_router.dart';
import 'package:community_wall/core/theme/app_theme.dart';

/// Punto de entrada de la aplicación.
///
/// Orden de inicialización:
/// 1. dotenv.load() — carga variables de entorno ANTES de Firebase
/// 2. Firebase.initializeApp() — usa los valores del .env
/// 3. ProviderScope — raíz del árbol de providers de Riverpod
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carga el archivo .env declarado en pubspec.yaml assets
  await dotenv.load(fileName: '.env');

  // Inicializa Firebase con las opciones leídas del .env
  await Firebase.initializeApp(options: Env.firebaseOptions);

  runApp(
    // ProviderScope es el contenedor raíz de todos los providers de Riverpod.
    // Sin él, ningún ConsumerWidget o ref.watch() funcionará.
    const ProviderScope(child: AppRoot()),
  );
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // El router es un provider porque necesita observar el estado de auth.
    // Cada vez que el usuario inicia/cierra sesión, el router reevalúa
    // su función redirect() y navega automáticamente.
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Community Wall',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
