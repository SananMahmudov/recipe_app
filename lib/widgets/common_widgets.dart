import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

// ── Convenience extension ────────────────────────────────────
extension AppContext on BuildContext {
  AppProvider get app => read<AppProvider>();
  AppProvider get watchApp => watch<AppProvider>();
  AppColors get colors => watch<AppProvider>().colors;
}

// ── Network image with fallback ──────────────────────────────
class AppImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final Widget child = (url != null && url!.isNotEmpty)
        ? CachedNetworkImage(
            imageUrl: url!,
            width: width,
            height: height,
            fit: fit,
            placeholder: (_, _) =>
                Container(color: colors.surface2, width: width, height: height),
            errorWidget: (_, _, _) => _fallback(colors),
          )
        : _fallback(colors);

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _fallback(AppColors colors) => Container(
        width: width,
        height: height,
        color: colors.surface2,
        child: Icon(Icons.restaurant, color: colors.textFaint, size: 28),
      );
}

// ── Spinner ──────────────────────────────────────────────────
class AppSpinner extends StatelessWidget {
  final String? label;
  const AppSpinner({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colors.accent,
              backgroundColor: colors.border,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 14),
            Text(label!, style: TextStyle(fontSize: 14, color: colors.textDim)),
          ],
        ],
      ),
    );
  }
}

// ── Empty / error state ──────────────────────────────────────
class StateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? hint;
  final Widget? action;

  const StateView({
    super.key,
    this.icon = Icons.restaurant,
    required this.title,
    this.hint,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 70),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: colors.accent, size: 30),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: colors.text),
            textAlign: TextAlign.center,
          ),
          if (hint != null) ...[
            const SizedBox(height: 8),
            Text(
              hint!,
              style: TextStyle(
                  fontSize: 14,
                  color: colors.textDim,
                  height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}

// ── Primary / soft / ghost button ───────────────────────────
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
          BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
      child: DefaultTextStyle(
        style: TextStyle(
            color: fg,
            fontSize: widget.small ? 14 : 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito'),
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

// ── Heart / favorite toggle ───────────────────────────────────
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
                : (widget.floating
                    ? Colors.white
                    : colors.textDim),
          ),
        ),
      ),
    );
  }
}

// ── Section header ───────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                  letterSpacing: -0.2),
            ),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.accent),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Cuisine / filter chip ────────────────────────────────────
class AppChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  final IconData? icon;

  const AppChip({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: active ? colors.accent : colors.surface2,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 15,
                  color: active ? colors.accentInk : colors.textDim),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? colors.accentInk : colors.textDim),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sticky frosted header ────────────────────────────────────
class AppHeader extends StatelessWidget {
  final String title;
  final String? sub;
  final bool large;
  final VoidCallback? onBack;
  final Widget? trailing;

  const AppHeader({
    super.key,
    required this.title,
    this.sub,
    this.large = false,
    this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.headerBg,
        border: Border(
          bottom: large
              ? BorderSide.none
              : BorderSide(color: colors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
          child: Row(
            children: [
              if (onBack != null) ...[
                _circleBtn(
                  context,
                  colors,
                  onTap: onBack!,
                  child: Icon(Icons.chevron_left,
                      size: 22, color: colors.text),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sub != null)
                      Text(sub!,
                          style: TextStyle(
                              fontSize: large ? 15 : 13,
                              fontWeight: FontWeight.w600,
                              color: colors.textDim)),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: large ? 28 : 18,
                          fontWeight: FontWeight.w800,
                          color: colors.text,
                          letterSpacing: -0.3),
                      overflow: large ? null : TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 10),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget _circleBtn(
    BuildContext context,
    AppColors colors, {
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: colors.surface2),
        child: child,
      ),
    );
  }
}

// ── Toast helper ─────────────────────────────────────────────
void showAppToast(BuildContext context, String message) {
  final colors = context.read<AppProvider>().colors;
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, size: 16, color: colors.accent),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                  color: colors.toastInk,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: colors.toastBg,
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1900),
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
    ),
  );
}
