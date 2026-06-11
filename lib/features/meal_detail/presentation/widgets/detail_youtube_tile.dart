import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../../../../core/network/meal_api_client.dart';

class DetailYoutubeTile extends StatelessWidget {
  final String ytId;
  final String url;

  const DetailYoutubeTile({super.key, required this.ytId, required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: url));
        if (context.mounted) showAppToast(context, t('linkCopied'));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                MealApiClient.youtubeThumbnail(ytId),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: colors.surface2),
              ),
            ),
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.65),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
            ),
            Positioned(
              bottom: 12, right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(t('watchVideo'),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
