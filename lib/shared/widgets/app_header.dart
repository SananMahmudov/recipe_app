import 'package:flutter/material.dart';
import '../../shared/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';

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
                _circleBtn(colors, onTap: onBack!,
                    child: Icon(Icons.chevron_left, size: 22, color: colors.text)),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sub != null)
                      Text(
                        sub!,
                        style: TextStyle(
                          fontSize: large ? 15 : 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textDim,
                        ),
                      ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: large ? 28 : 18,
                        fontWeight: FontWeight.w800,
                        color: colors.text,
                        letterSpacing: -0.3,
                      ),
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

  Widget _circleBtn(AppColors colors,
      {required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: colors.surface2),
        child: child,
      ),
    );
  }
}
