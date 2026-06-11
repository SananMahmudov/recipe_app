import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../shared/extensions/context_extensions.dart';

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
            placeholder: (_, _) => Container(
              color: colors.surface2,
              width: width,
              height: height,
            ),
            errorWidget: (_, _, _) => _fallback(colors.surface2, colors.textFaint),
          )
        : _fallback(colors.surface2, colors.textFaint);

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _fallback(Color bg, Color icon) => Container(
        width: width,
        height: height,
        color: bg,
        child: Icon(Icons.restaurant, color: icon, size: 28),
      );
}
