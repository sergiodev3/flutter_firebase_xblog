import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:community_wall/core/constants/app_constants.dart';
import 'package:community_wall/presentation/viewmodels/posts_viewmodel.dart';
import 'package:community_wall/presentation/widgets/app_text_field.dart';

class CreateEditPostScreen extends ConsumerStatefulWidget {
  /// Si es null → modo crear. Si tiene valor → modo editar.
  final String? postId;

  const CreateEditPostScreen({super.key, this.postId});

  bool get isEditing => postId != null;

  @override
  ConsumerState<CreateEditPostScreen> createState() =>
      _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends ConsumerState<CreateEditPostScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _contentCtrl = TextEditingController();
  String? _selectedImagePath;
  bool _removeExistingImage = false;

  late final AnimationController _imageAnimCtrl;

  @override
  void initState() {
    super.initState();
    _imageAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _imageAnimCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // Comprime la imagen para reducir uso de Storage
      maxWidth: 1200,
    );
    if (picked != null) {
      setState(() {
        _selectedImagePath = picked.path;
        _removeExistingImage = false;
      });
      _imageAnimCtrl.forward(from: 0);
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImagePath = null;
      _removeExistingImage = true;
    });
    _imageAnimCtrl.reverse();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final content = _contentCtrl.text.trim();

    if (widget.isEditing) {
      // imagePath vacío indica "eliminar la imagen existente"
      final imagePath = _removeExistingImage
          ? ''
          : _selectedImagePath;
      await ref.read(postsViewModelProvider.notifier).updatePost(
            widget.postId!,
            content,
            imagePath: imagePath,
          );
    } else {
      await ref.read(postsViewModelProvider.notifier).createPost(
            content,
            imagePath: _selectedImagePath,
          );
    }

    if (mounted) {
      final state = ref.read(postsViewModelProvider);
      if (!state.hasError) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(postsViewModelProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    });

    final isLoading = ref.watch(postsViewModelProvider).isLoading;
    final hasImage =
        _selectedImagePath != null || false; // extend with edit state if needed

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar Mensaje' : 'Nuevo Mensaje'),
        leading: BackButton(onPressed: isLoading ? null : () => context.pop()),
        actions: [
          TextButton.icon(
            onPressed: isLoading ? null : _submit,
            icon: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(widget.isEditing ? 'Guardar' : 'Publicar'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Campo de texto del post ─────────────────────
                AppTextField(
                  controller: _contentCtrl,
                  label: '¿Qué quieres compartir?',
                  hint: 'Escribe tu mensaje aquí...',
                  maxLines: 6,
                  maxLength: AppConstants.maxPostLength,
                  autofocus: true,
                  enabled: !isLoading,
                  validator: Validators.postContent,
                ),
                const SizedBox(height: 16),

                // ── Preview de imagen seleccionada ──────────────
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: hasImage
                      ? _ImagePreview(
                          imagePath: _selectedImagePath!,
                          onRemove: _removeImage,
                        )
                      : const SizedBox.shrink(),
                ),

                // ── Botón para adjuntar foto ────────────────────
                if (!hasImage)
                  OutlinedButton.icon(
                    onPressed: isLoading ? null : _pickImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Agregar foto'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget de preview de imagen con botón para eliminarla.
class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imagePath, required this.onRemove});

  final String imagePath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(imagePath),
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onRemove,
              tooltip: 'Eliminar foto',
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
