import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../features/app_settings/presentation/cubit/app_settings_cubit.dart';

extension AppContext on BuildContext {
  AppSettingsCubit get settingsCubit => read<AppSettingsCubit>();
  AppColors get colors => watch<AppSettingsCubit>().state.colors;
  String t(String key) => watch<AppSettingsCubit>().state.t(key);
}
