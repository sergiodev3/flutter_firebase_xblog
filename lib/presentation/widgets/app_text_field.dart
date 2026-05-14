import 'package:flutter/material.dart';

/// Campo de texto reutilizable con estilo consistente en toda la app.
/// Encapsula [TextFormField] para no repetir la misma configuración
/// en cada pantalla de formulario.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = false,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool autofocus;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: maxLines != null && maxLines! > 1
            ? TextInputType.multiline
            : keyboardType,
        maxLines: obscureText ? 1 : maxLines,
        maxLength: maxLength,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        autofocus: autofocus,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}

/// Validadores reutilizables para formularios.
abstract final class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'El correo es requerido.';
    final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Ingresa un correo válido.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'La contraseña es requerida.';
    if (value.length < 6) return 'Mínimo 6 caracteres.';
    return null;
  }

  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) return 'El nombre es requerido.';
    if (value.trim().length < 2) return 'Mínimo 2 caracteres.';
    return null;
  }

  static String? postContent(String? value) {
    if (value == null || value.trim().isEmpty) return 'El mensaje no puede estar vacío.';
    if (value.trim().length > 500) return 'Máximo 500 caracteres.';
    return null;
  }

  static String? Function(String?) confirmPassword(
    TextEditingController passwordController,
  ) =>
      (value) {
        if (value != passwordController.text) return 'Las contraseñas no coinciden.';
        return null;
      };
}
