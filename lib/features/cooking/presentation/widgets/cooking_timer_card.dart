import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../cubit/cooking_cubit.dart';

class CookingTimerCard extends StatelessWidget {
  const CookingTimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;
    final cubit = context.watch<CookingCubit>();
    final state = cubit.state;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [colors.cardShadow],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 20, color: colors.textDim),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  state.formattedTime,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: (state.secs == 0 && !state.running)
                        ? colors.textFaint
                        : colors.text,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              GestureDetector(
                onTap: cubit.startStop,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: state.secs == 0 ? colors.surface2 : colors.accent,
                  ),
                  child: Icon(
                    state.running ? Icons.pause : Icons.play_arrow,
                    size: 20,
                    color: state.secs == 0 ? colors.textFaint : colors.accentInk,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: cubit.resetTimer,
                child: Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: colors.surface2),
                  child: Icon(Icons.replay, size: 19, color: colors.textDim),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [1, 5, 10, 15].map((m) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => cubit.addMinutes(m),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.surface2,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(
                        '+$m${t('minutes')}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13.5, fontWeight: FontWeight.w700, color: colors.text),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
