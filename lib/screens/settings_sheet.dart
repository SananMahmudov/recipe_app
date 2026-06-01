import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final colors = provider.colors;
    final t = provider.t;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(t('settings'),
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: colors.text)),
          const SizedBox(height: 20),
          _SettingRow(
            label: t('darkMode'),
            colors: colors,
            trailing: Switch(
              value: provider.isDark,
              onChanged: (_) => provider.toggleDark(),
              activeThumbColor: colors.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(t('accentColor'),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textDim)),
          const SizedBox(height: 10),
          Row(
            children: AppColors.accentOptions.map((c) {
              final active =
                  provider.accent.toARGB32() == c.toARGB32();
              return GestureDetector(
                onTap: () => provider.setAccent(c),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: active
                        ? Border.all(color: colors.text, width: 2.5)
                        : null,
                  ),
                  child: active
                      ? Icon(Icons.check,
                          size: 18, color: provider.colors.accentInk)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(t('density'),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textDim)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.surface2,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: ['cozy', 'compact', 'spacious'].map((d) {
                final active = provider.density == d;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => provider.setDensity(d),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding:
                          const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: active
                            ? colors.surface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow:
                            active ? [colors.cardShadow] : null,
                      ),
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: active
                                ? colors.text
                                : colors.textDim),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final dynamic colors;
  final Widget trailing;

  const _SettingRow(
      {required this.label,
      required this.colors,
      required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.text)),
        ),
        trailing,
      ],
    );
  }
}
