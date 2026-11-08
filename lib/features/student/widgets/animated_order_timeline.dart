import 'package:flutter/material.dart';

class AnimatedOrderTimeline extends StatelessWidget {
  final String status; // 'placed', 'preparing', 'ready', 'completed'

  const AnimatedOrderTimeline({super.key, required this.status});

  int get _currentStepIndex {
    switch (status.toLowerCase()) {
      case 'placed':
        return 0;
      case 'preparing':
        return 1;
      case 'ready':
      case 'completed':
        return 2;
      default:
        return 0;
    }
  }

  double get _progressValue {
    switch (_currentStepIndex) {
      case 0:
        return 0.0;
      case 1:
        return 0.5;
      case 2:
        return 1.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth - 48;

            return Stack(
              alignment: Alignment.center,
              children: [
                // Background Inactive Bar Track
                Container(
                  height: 4,
                  width: trackWidth,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Animated Active Progress Fill Bar
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                      tween: Tween<double>(begin: 0.0, end: _progressValue),
                      builder: (context, value, child) {
                        return Container(
                          height: 4,
                          width: trackWidth * value,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Step Nodes Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStepNode(
                      context,
                      stepIndex: 0,
                      label: 'Placed',
                      icon: Icons.receipt_long_rounded,
                      activeColor: Colors.blue,
                    ),
                    _buildStepNode(
                      context,
                      stepIndex: 1,
                      label: 'Preparing',
                      icon: Icons.soup_kitchen_rounded,
                      activeColor: Colors.orange,
                    ),
                    _buildStepNode(
                      context,
                      stepIndex: 2,
                      label: 'Ready',
                      icon: Icons.check_circle_rounded,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStepNode(
    BuildContext context, {
    required int stepIndex,
    required String label,
    required IconData icon,
    required Color activeColor,
  }) {
    final isReached = _currentStepIndex >= stepIndex;
    final isCurrent = _currentStepIndex == stepIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isCurrent ? 10 : 8),
          decoration: BoxDecoration(
            color: isReached ? activeColor : Theme.of(context).cardColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isReached ? activeColor : Colors.grey.shade400,
              width: 2,
            ),
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ]
                : [],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Icon(
              icon,
              key: ValueKey<bool>(isReached),
              size: isCurrent ? 20 : 16,
              color: isReached ? Colors.white : Colors.grey.shade400,
            ),
          ),
        ),
        const SizedBox(height: 6),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 12,
            fontWeight: isReached ? FontWeight.bold : FontWeight.normal,
            color: isReached
                ? (isCurrent ? activeColor : Colors.grey.shade800)
                : Colors.grey.shade500,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
