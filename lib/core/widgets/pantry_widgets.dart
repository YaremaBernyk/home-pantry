import 'package:flutter/material.dart';

abstract final class PantryColors {
  static const background = Color(0xFFF7F4EE);
  static const accent = Color(0xFFB65D42);
  static const ink = Color(0xFF332D29);
  static const muted = Color(0xFF998C84);
  static const border = Color(0xFFE3D8CF);
  static const selected = Color(0xFFF8EBE7);
}

class PantryCard extends StatelessWidget {
  const PantryCard({super.key, required this.child, this.padding = 24});
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: PantryColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x05000000),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: child,
  );
}

class PantryField extends StatelessWidget {
  const PantryField({
    super.key,
    this.label,
    required this.hint,
    this.secret = false,
    this.helper,
    this.keyboardType,
    this.controller,
  });
  final String? label;
  final String hint;
  final bool secret;
  final String? helper;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
        ],
        TextField(
          controller: controller,
          obscureText: secret,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint),
        ),
        if (helper != null) ...[
          const SizedBox(height: 6),
          Text(
            helper!,
            style: const TextStyle(color: PantryColors.muted, fontSize: 12),
          ),
        ],
      ],
    ),
  );
}

class PantryButton extends StatelessWidget {
  const PantryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: PantryColors.accent,
      foregroundColor: Colors.white,
      minimumSize: const Size(0, 50),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

void showDemoNotice(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
