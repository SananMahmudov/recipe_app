import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_btn.dart';
import '../cubit/cooking_cubit.dart';

class CookingNavButtons extends StatelessWidget {
  final int total;

  const CookingNavButtons({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cubit = context.read<CookingCubit>();
    final stepIndex = context.watch<CookingCubit>().state.stepIndex;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: [
          if (stepIndex > 0) ...[
            Expanded(
              child: AppBtn(
                variant: AppBtnVariant.ghost,
                fullWidth: true,
                onTap: cubit.prev,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chevron_left),
                    const SizedBox(width: 4),
                    Text(t('prev')),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: AppBtn(
              fullWidth: true,
              onTap: cubit.next,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(stepIndex + 1 >= total ? t('finishCooking') : t('next')),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
