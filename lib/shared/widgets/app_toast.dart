import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/app_settings/presentation/cubit/app_settings_cubit.dart';

void showAppToast(BuildContext context, String message) {
  final colors = context.read<AppSettingsCubit>().state.colors;
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
                fontSize: 14,
              ),
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
