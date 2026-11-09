import 'dart:async';
import 'package:flutter/material.dart';

class PrepCountdownTimer extends StatefulWidget {
  final DateTime createdAt;
  final int estimatedPrepMinutes;
  final String status;

  const PrepCountdownTimer({
    super.key,
    required this.createdAt,
    required this.estimatedPrepMinutes,
    required this.status,
  });

  @override
  State<PrepCountdownTimer> createState() => _PrepCountdownTimerState();
}

class _PrepCountdownTimerState extends State<PrepCountdownTimer> {
  Timer? _timer;
  late Duration _remainingDuration;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant PrepCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.createdAt != widget.createdAt) {
      _calculateRemainingTime();
    }
  }

  void _calculateRemainingTime() {
    final targetTime = widget.createdAt.add(
      Duration(minutes: widget.estimatedPrepMinutes),
    );
    final now = DateTime.now();
    final difference = targetTime.difference(now);

    setState(() {
      _remainingDuration = difference.isNegative ? Duration.zero : difference;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      final targetTime = widget.createdAt.add(
        Duration(minutes: widget.estimatedPrepMinutes),
      );
      final now = DateTime.now();
      final difference = targetTime.difference(now);

      if (difference.isNegative) {
        setState(() {
          _remainingDuration = Duration.zero;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _remainingDuration = difference;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isPreparing = widget.status.toLowerCase() == 'preparing';
    final isReady =
        widget.status.toLowerCase() == 'ready' ||
        widget.status.toLowerCase() == 'completed';

    if (isReady) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stars_rounded, color: Colors.green, size: 18),
            SizedBox(width: 6),
            Text(
              'Order is Ready! Please collect from counter.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    if (!isPreparing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time_rounded, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Text(
              'Estimated Prep Time: ${widget.estimatedPrepMinutes} mins',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
    }

    final isExpired = _remainingDuration == Duration.zero;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isExpired ? Colors.orange.shade50 : Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isExpired ? Colors.orange.shade300 : Colors.amber.shade300,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isExpired
                    ? Icons.hourglass_bottom_rounded
                    : Icons.timer_outlined,
                color: isExpired
                    ? Colors.orange.shade800
                    : Colors.amber.shade900,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                isExpired
                    ? 'Almost ready! Finalizing...'
                    : 'Est. Time Remaining:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isExpired
                      ? Colors.orange.shade900
                      : Colors.amber.shade900,
                ),
              ),
            ],
          ),
          if (!isExpired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber.shade400),
              ),
              child: Text(
                _formatDuration(_remainingDuration),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: Colors.amber.shade900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
