import 'package:flutter/material.dart';

import 'custom_button.dart';

class WatchConnectionBanner extends StatefulWidget {
  final bool isConnected;
  final VoidCallback onConnect;
  final VoidCallback? onDisconnect;
  final int? batteryLevel;
  final int? signalStrength;
  final DateTime? lastSyncTime;

  const WatchConnectionBanner({
    super.key,
    required this.isConnected,
    required this.onConnect,
    this.onDisconnect,
    this.batteryLevel,
    this.signalStrength,
    this.lastSyncTime,
  });

  @override
  State<WatchConnectionBanner> createState() => _WatchConnectionBannerState();
}

class _WatchConnectionBannerState extends State<WatchConnectionBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isConnected) {
      _pulseController.repeat();
    }
  }

  @override
  void didUpdateWidget(WatchConnectionBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnected && !oldWidget.isConnected) {
      _pulseController.repeat();
    } else if (!widget.isConnected && oldWidget.isConnected) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              widget.isConnected
                  ? [const Color(0xFF10B981), const Color(0xFF059669)]
                  : [const Color(0xFF7ED6D6), const Color(0xFF5BC0DE)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (widget.isConnected
                    ? const Color(0xFF10B981)
                    : const Color(0xFF7ED6D6))
                .withAlpha((0.3 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated Watch Icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isConnected ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.2 * 255).toInt()),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    widget.isConnected ? Icons.watch : Icons.watch_off,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Text
                Text(
                  widget.isConnected
                      ? 'Watch Connected!'
                      : 'Watch Disconnected',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                // Status Description
                Text(
                  widget.isConnected
                      ? 'Your watch is actively monitoring your health'
                      : 'Connect your watch to start monitoring',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha((0.9 * 255).toInt()),
                  ),
                ),

                // Connection Info (if connected)
                if (widget.isConnected &&
                    (widget.batteryLevel != null ||
                        widget.signalStrength != null)) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.batteryLevel != null) ...[
                        const Icon(Icons.battery_full, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.batteryLevel}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (widget.signalStrength != null) ...[
                        const Icon(
                          Icons.signal_cellular_4_bar,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.signalStrength}/5',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                const SizedBox(height: 12),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: widget.isConnected ? 'DISCONNECT' : 'CONNECT WATCH',
                    onPressed:
                        widget.isConnected
                            ? widget.onDisconnect
                            : widget.onConnect,
                    icon:
                        widget.isConnected
                            ? Icons.bluetooth_disabled
                            : Icons.bluetooth_connected,
                    backgroundColor: Colors.white.withAlpha(
                      (0.2 * 255).toInt(),
                    ),
                    textColor: Colors.white,
                    isSecondary: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
