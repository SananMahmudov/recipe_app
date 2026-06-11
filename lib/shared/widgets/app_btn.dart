import 'package:flutter/material.dart';
import '../../shared/extensions/context_extensions.dart';

enum AppBtnVariant { solid, soft, ghost, outline }

class AppBtn extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final AppBtnVariant variant;
  final bool fullWidth;
  final bool small;
  final EdgeInsets? padding;

  const AppBtn({
    super.key,
    required this.child,
    this.onTap,
    this.variant = AppBtnVariant.solid,
    this.fullWidth = false,
    this.small = false,
    this.padding,
  });

  @override
  State<AppBtn> createState() => _AppBtnState();
}

class _AppBtnState extends State<AppBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final disabled = widget.onTap == null;

    Color bg;
    Color fg;
    BoxDecoration? decoration;

    switch (widget.variant) {
      case AppBtnVariant.solid:
        bg = colors.accent;
        fg = colors.accentInk;
      case AppBtnVariant.soft:
        bg = colors.accentSoft;
        fg = colors.accent;
      case AppBtnVariant.ghost:
        bg = colors.surface2;
        fg = colors.text;
      case AppBtnVariant.outline:
        bg = Colors.transparent;
        fg = colors.text;
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: colors.borderStrong, width: 1.5),
        );
    }

    final inner = Container(
      padding: widget.padding ??
          (widget.small
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 9)
              : const EdgeInsets.symmetric(horizontal: 22, vertical: 14)),
      decoration: decoration ??
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: DefaultTextStyle(
        style: TextStyle(
          color: fg,
          fontSize: widget.small ? 14 : 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito',
        ),
        child: IconTheme(
          data: IconThemeData(color: fg, size: widget.small ? 16 : 18),
          child: widget.child,
        ),
      ),
    );

    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 80),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: GestureDetector(
          onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
          onTapUp: disabled ? null : (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: widget.fullWidth
              ? SizedBox(width: double.infinity, child: inner)
              : inner,
        ),
      ),
    );
  }
}
