import 'package:flutter/material.dart';
import '../../../../shared/extensions/context_extensions.dart';

class CookingDoneView extends StatelessWidget {
  const CookingDoneView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: colors.accentGradient),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 92, height: 92,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: colors.accentInk),
                    child: Icon(Icons.check, size: 48, color: colors.accent),
                  ),
                  const SizedBox(height: 22),
                  Text(t('cookingDone'),
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w800,
                          color: colors.accentInk)),
                  const SizedBox(height: 8),
                  Text(t('cookingDoneSub'),
                      style: TextStyle(
                          fontSize: 16,
                          color: colors.accentInk.withValues(alpha: 0.78))),
                  const SizedBox(height: 28),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 14),
                      decoration: BoxDecoration(
                        color: colors.accentInk,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(t('backToRecipe'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colors.accent)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
