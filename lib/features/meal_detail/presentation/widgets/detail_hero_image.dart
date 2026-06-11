import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_image.dart';

class DetailHeroImage extends StatelessWidget {
  final String thumbUrl;

  const DetailHeroImage({super.key, required this.thumbUrl});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Stack(
      children: [
        SizedBox(
          height: 320,
          width: double.infinity,
          child: AppImage(url: thumbUrl),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          height: 140,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, colors.detailFade],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
