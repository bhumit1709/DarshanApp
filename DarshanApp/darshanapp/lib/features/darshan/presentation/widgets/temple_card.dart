import 'package:flutter/material.dart';
import '../../domain/entities/temple.dart';

class TempleCard extends StatefulWidget {
  final Temple temple;
  final VoidCallback onDarshanPressed;

  const TempleCard({
    super.key,
    required this.temple,
    required this.onDarshanPressed,
  });

  @override
  State<TempleCard> createState() => _TempleCardState();
}

class _TempleCardState extends State<TempleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       duration: const Duration(milliseconds: 150),
       vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onDarshanPressed,
        child: Container(
          decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(24),
             boxShadow: [
               BoxShadow(
                 color: Colors.black.withOpacity(0.3),
                 blurRadius: 10,
                 offset: const Offset(0, 4),
               ),
             ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                Image.asset(
                  widget.temple.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF2D1F16),
                    child: const Center(
                      child: Icon(Icons.temple_hindu, size: 40, color: Colors.white24),
                    ),
                  ),
                ),
                
                // Gradient Overlay
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),

                // Live Badge
                if (widget.temple.isLive)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 6, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Play Icon Overlay (Center)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                  ),
                ),

                // Bottom Content
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.temple.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Serif',
                          height: 1.1,
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 12, color: Color(0xFFFFD54F)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.temple.location,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: const Color(0xFFFFD54F).withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

