
import 'package:flutter/material.dart';

enum LiButtonType { primary, secondary, outline }

class LiButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final LiButtonType type;
  final bool isLoading;

  const LiButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = LiButtonType.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine styles based on type
    final Color backgroundColor;
    final Color foregroundColor;
    final BorderSide? border;

    switch (type) {
      case LiButtonType.primary:
        backgroundColor = Theme.of(context).primaryColor;
        foregroundColor = Colors.white;
        border = null;
        break;
      case LiButtonType.secondary:
        backgroundColor = Theme.of(context).colorScheme.secondary;
        foregroundColor = Colors.white;
        border = null;
        break;
      case LiButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = Theme.of(context).primaryColor;
        border = BorderSide(color: Theme.of(context).primaryColor);
        break;
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: border ?? BorderSide.none,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
