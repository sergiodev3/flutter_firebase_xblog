import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:community_wall/core/router/app_router.dart';
import 'package:community_wall/presentation/viewmodels/auth_viewmodel.dart';
import 'package:community_wall/presentation/viewmodels/posts_viewmodel.dart';
import 'package:community_wall/presentation/widgets/post_card.dart';
import 'package:community_wall/presentation/widgets/post_shimmer.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsStreamProvider);
    final currentUser = ref.watch(authViewModelProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Wall'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Cerrar sesión',
            onPressed: () => _confirmSignOut(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createPost),
        icon: const Icon(Icons.edit_outlined),
        label: const Text('Publicar'),
      ),
      body: postsAsync.when(
        // Estado de carga: muestra 6 esqueletos shimmer
        loading: () => ListView.builder(
          itemCount: 6,
          itemBuilder: (_, i) => const PostShimmer(),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off_rounded,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar los mensajes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '¡Sé el primero en publicar!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // El stream de Firestore actualiza automáticamente,
              // el pull-to-refresh es solo feedback visual para el usuario.
              ref.invalidate(postsStreamProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final isOwner = currentUser != null &&
                    post.isOwnedBy(currentUser.uid);

                // AnimatedSwitcher da un efecto de fade entre actualizaciones
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: PostCard(
                    key: ValueKey(post.id),
                    post: post,
                    isOwner: isOwner,
                    onEdit: () => context.push(
                      '${AppRoutes.editPost}/${post.id}',
                    ),
                    onDelete: () => _confirmDelete(context, ref, post.id),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String postId,
  ) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar publicación'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar este mensaje? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(postsViewModelProvider.notifier).deletePost(postId);
      }
    });
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Quieres cerrar tu sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(authViewModelProvider.notifier).signOut();
      }
    });
  }
}
