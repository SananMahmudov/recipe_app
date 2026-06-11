import 'package:flutter/material.dart';
import '../../shared/extensions/context_extensions.dart';

class HeartBtn extends StatefulWidget {
  final bool active;
  final VoidCallback onTap;
  final double size;
  final bool floating;

  const HeartBtn({
    super.key,
    required this.active,
    required this.onTap,
    this.size = 36,
    this.floating = false,
  });

  @override
  State<HeartBtn> createState() => _HeartBtnState();
}

class _HeartBtnState extends State<HeartBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconSize = widget.size * 0.5;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.floating
                ? Colors.black.withValues(alpha: 0.42)
                : colors.surface2,
          ),
          child: Icon(
            widget.active ? Icons.favorite : Icons.favorite_border,
            size: iconSize,
            color: widget.active
                ? colors.accent
                : (widget.floating ? Colors.white : colors.textDim),
          ),
        ),
      ),
    );
  }
}
