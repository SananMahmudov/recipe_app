import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';

class HomeRandomBanner extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const HomeRandomBanner({
    super.key,
    required this.loading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: colors.accentGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [colors.cardShadow],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18, top: -18,
            child: Opacity(
              opacity: 0.18,
              child: Icon(Icons.shuffle, size: 120, color: colors.accentInk),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t('randomTitle'),
                  style: TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w800,
                      color: colors.accentInk, height: 1.2)),
              const SizedBox(height: 6),
              Text(t('randomSub'),
                  style: TextStyle(fontSize: 14,
                      color: colors.accentInk.withValues(alpha: 0.75))),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: loading ? null : onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                  decoration: BoxDecoration(
                    color: colors.accentInk,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      loading
                          ? SizedBox(width: 17, height: 17,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: colors.accent))
                          : Icon(Icons.shuffle, size: 17, color: colors.accent),
                      const SizedBox(width: 8),
                      Text(t('randomCta'),
                          style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w700, color: colors.accent)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
