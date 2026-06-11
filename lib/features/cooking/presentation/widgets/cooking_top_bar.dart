import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../cubit/cooking_cubit.dart';

class CookingTopBar extends StatelessWidget {
  final String mealName;
  final int total;

  const CookingTopBar({
    super.key,
    required this.mealName,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final stepIndex = context.watch<CookingCubit>().state.stepIndex;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: colors.surface2),
                  child: Icon(Icons.close, size: 20, color: colors.text),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mealName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, color: colors.text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (int i = 0; i < total; i++) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= stepIndex ? colors.accent : colors.surface2,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                if (i < total - 1) const SizedBox(width: 4),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
