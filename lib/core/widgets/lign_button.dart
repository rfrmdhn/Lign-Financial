import 'package:flutter/material.dart';
import 'package:lign_financial/core/themes/app_colors.dart';

enum LignButtonType { primary, secondary }

class LignButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LignButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const LignButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = LignButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = type == LignButtonType.primary
        ? ElevatedButton.styleFrom(
            backgroundColor: LignColors.electricLime,
            foregroundColor: LignColors.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: LignColors.textPrimary,
            side: const BorderSide(color: LignColors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          );

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: type == LignButtonType.primary ? LignColors.textPrimary : LignColors.electricLime,
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(text),
      ],
    );

    Widget button;
    if (type == LignButtonType.primary) {
      button = ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: content,
      );
    } else {
      button = OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: content,
      );
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
