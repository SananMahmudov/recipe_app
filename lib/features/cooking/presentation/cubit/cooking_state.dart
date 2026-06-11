class CookingState {
  final int stepIndex;
  final bool done;
  final int secs;
  final bool running;

  const CookingState({
    this.stepIndex = 0,
    this.done = false,
    this.secs = 0,
    this.running = false,
  });

  CookingState copyWith({
    int? stepIndex,
    bool? done,
    int? secs,
    bool? running,
  }) =>
      CookingState(
        stepIndex: stepIndex ?? this.stepIndex,
        done: done ?? this.done,
        secs: secs ?? this.secs,
        running: running ?? this.running,
      );

  String get formattedTime {
    final m = secs ~/ 60;
    final s = secs % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
