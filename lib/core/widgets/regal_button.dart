import 'package:flutter/material.dart';
import '../theme/theme.dart';

class RegalButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const RegalButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  State<RegalButton> createState() => _RegalButtonState();
}

class _RegalButtonState extends State<RegalButton> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() => _scale = 0.96);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      setState(() => _scale = 1.0);
    }
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey[400] : KalyaThiruTheme.primaryMaroon,
            borderRadius: BorderRadius.circular(4),
            boxShadow: isDisabled
                ? []
                : [
                    const BoxShadow(
                      color: Color(0x33570013),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Golden shimmer effect
              if (!isDisabled)
                AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: FractionallySizedBox(
                        alignment: Alignment(
                          -2.0 + (_shimmerController.value * 4.0),
                          0.0,
                        ),
                        widthFactor: 0.3,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.0),
                                KalyaThiruTheme.antiqueGold.withOpacity(0.25),
                                Colors.white.withOpacity(0.0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              // Button content
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ) ??
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                    if (widget.icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
