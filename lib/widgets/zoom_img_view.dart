import 'package:flutter/material.dart';
import 'network_imge_view.dart';

class ZoomImageView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const ZoomImageView({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<ZoomImageView> createState() => _ZoomImageViewState();
}

class _ZoomImageViewState extends State<ZoomImageView> {
  late PageController _pageController;
  late TransformationController _transformationController;
  late int _currentIndex;
  double _currentScale = 1.0;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
        _currentScale = 1.0;
      }
    });
  }

  void _goToPreviousImage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextImage() {
    if (_currentIndex < widget.images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      // Reset zoom
      _transformationController.value = Matrix4.identity();
      setState(() => _currentScale = 1.0);
    } else {
      // Zoom in 3x at tap position
      final position = _doubleTapDetails!.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      setState(() => _currentScale = 3.0);
    }
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onTap,
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: onTap != null 
              ? Colors.black.withValues(alpha:0.4)
              : Colors.black.withValues(alpha:0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: onTap != null 
                ? Colors.white.withValues(alpha:0.2)
                : Colors.white.withValues(alpha:0.1),
          ),
        ),
        child: Icon(
          icon,
          color: onTap != null 
              ? Colors.white
              : Colors.white.withValues(alpha:0.3),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return SafeArea(
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                // Image counter
                if (widget.images.length > 1)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha:0.2)),
                    ),
                    child: Text(
                      '${_currentIndex + 1} of ${widget.images.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const Spacer(),
                // Close button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:0.4),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha:0.2)),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
      
          const Spacer(),
      
          // Navigation buttons (only show if there are multiple images)
          if (widget.images.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  _buildNavigationButton(
                    icon: Icons.chevron_left,
                    onTap: _currentIndex > 0 ? _goToPreviousImage : null,
                    isLeft: true,
                  ),
                  // Next button
                  _buildNavigationButton(
                    icon: Icons.chevron_right,
                    onTap: _currentIndex < widget.images.length - 1 
                        ? _goToNextImage 
                        : null,
                    isLeft: false,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image viewer
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.images.length,
            itemBuilder: (context, index) => GestureDetector(
              onDoubleTapDown: (details) => _doubleTapDetails = details,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 1.0,
                maxScale: 4.0,
                panEnabled: _currentScale != 1.0,
                onInteractionEnd: (details) {
                  final scale =
                      _transformationController.value.getMaxScaleOnAxis();
                  setState(() => _currentScale = scale);
                },
                child: Center(
                  child: NetworkImageView(url: widget.images[index]),
                ),
              ),
            ),
          ),

          // Overlay controls
          _buildOverlay(),
        ],
      ),
    );
  }
}