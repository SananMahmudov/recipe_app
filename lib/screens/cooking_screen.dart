import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../widgets/common_widgets.dart';

class CookingScreen extends StatefulWidget {
  final Meal meal;
  final List<String> steps;

  const CookingScreen({
    super.key,
    required this.meal,
    required this.steps,
  });

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  int _stepIndex = 0;
  bool _done = false;

  // Timer state
  int _secs = 0;
  bool _running = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startStop() {
    if (_secs == 0) return;
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      setState(() => _running = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_secs <= 1) {
          _timer?.cancel();
          setState(() {
            _secs = 0;
            _running = false;
          });
        } else {
          setState(() => _secs--);
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secs = 0;
      _running = false;
    });
  }

  void _addMinutes(int m) {
    setState(() => _secs = (_secs + m * 60).clamp(0, 5999));
  }

  String _fmt(int s) {
    final m = s ~/ 60;
    final ss = s % 60;
    return '$m:${ss.toString().padLeft(2, '0')}';
  }

  void _next() {
    if (_stepIndex + 1 >= widget.steps.length) {
      setState(() => _done = true);
    } else {
      setState(() => _stepIndex++);
    }
  }

  void _prev() {
    if (_stepIndex > 0) setState(() => _stepIndex--);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final colors = provider.colors;
    final t = provider.t;

    if (_done) return _DoneView(colors: colors, t: t);

    final total = widget.steps.length;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.surface2,
                          ),
                          child: Icon(Icons.close,
                              size: 20, color: colors.text),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.meal.strMeal,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colors.text),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // progress segments
                  Row(
                    children: [
                      for (int i = 0; i < total; i++) ...[
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 4,
                            decoration: BoxDecoration(
                              color: i <= _stepIndex
                                  ? colors.accent
                                  : colors.surface2,
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
            ),

            // ── Step body ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${t('step')} ${_stepIndex + 1} ${t('of')} $total',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: colors.accent,
                          letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.steps[_stepIndex],
                      style: TextStyle(
                          fontSize: 22,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: colors.text),
                    ),
                  ],
                ),
              ),
            ),

            // ── Timer card ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Container(
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
                        Icon(Icons.timer_outlined,
                            size: 20, color: colors.textDim),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _fmt(_secs),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: (_secs == 0 && !_running)
                                  ? colors.textFaint
                                  : colors.text,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                        ),
                        // play/pause
                        GestureDetector(
                          onTap: _startStop,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _secs == 0
                                  ? colors.surface2
                                  : colors.accent,
                            ),
                            child: Icon(
                              _running ? Icons.pause : Icons.play_arrow,
                              size: 20,
                              color: _secs == 0
                                  ? colors.textFaint
                                  : colors.accentInk,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // reset
                        GestureDetector(
                          onTap: _resetTimer,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.surface2,
                            ),
                            child: Icon(Icons.replay,
                                size: 19, color: colors.textDim),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [1, 5, 10, 15].map((m) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4),
                            child: GestureDetector(
                              onTap: () => _addMinutes(m),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                                decoration: BoxDecoration(
                                  color: colors.surface2,
                                  borderRadius:
                                      BorderRadius.circular(11),
                                ),
                                child: Text(
                                  '+$m${t('minutes')}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: colors.text),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // ── Nav buttons ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  if (_stepIndex > 0) ...[
                    Expanded(
                      child: AppBtn(
                        variant: AppBtnVariant.ghost,
                        fullWidth: true,
                        onTap: _prev,
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
                      onTap: _next,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_stepIndex + 1 >= total
                              ? t('finishCooking')
                              : t('next')),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneView extends StatelessWidget {
  final dynamic colors;
  final String Function(String) t;

  const _DoneView({required this.colors, required this.t});

  @override
  Widget build(BuildContext context) {
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
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.accentInk,
                    ),
                    child: Icon(Icons.check,
                        size: 48, color: colors.accent),
                  ),
                  const SizedBox(height: 22),
                  Text(t('cookingDone'),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: colors.accentInk)),
                  const SizedBox(height: 8),
                  Text(t('cookingDoneSub'),
                      style: TextStyle(
                          fontSize: 16,
                          color: colors.accentInk
                              .withValues(alpha: 0.78))),
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
