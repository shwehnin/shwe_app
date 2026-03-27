import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../utils/global.dart';
import '../../../utils/reusable.dart';
import '../../../data/models/slider_model.dart';
import '../../../widgets/network_imge_view.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentIndex = 0;

  Widget _buildImageSlide(SliderModel slider) {
    return GestureDetector(
      onTap: () => Reusable.openURL(slider.url),
      child: Stack(
        children: [
          NetworkImageView(
            url: slider.cover,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Reusable.openURL(slider.url),
                splashColor: Colors.white.withValues(alpha: 0.2),
                highlightColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalIndicators(int total) {
    if (total <= 1) return const SizedBox.shrink();

    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (index) {
          final isActive = _currentIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isActive ? 20.0 : 6.0,
            height: 6.0,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.4),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<SliderModel> imgList = [...(Global.config.slider ?? [])];

    if (imgList.isEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOutCubic,
                enableInfiniteScroll: true,
                height: double.infinity,
                onPageChanged: (index, _) =>
                    setState(() => _currentIndex = index),
              ),
              items: imgList.map(_buildImageSlide).toList(),
            ),
          ),
          _buildHorizontalIndicators(imgList.length),
        ],
      ),
    );
  }
}
