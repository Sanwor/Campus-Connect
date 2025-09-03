import 'package:flutter/material.dart';

class CustomDisplayNetworkImage extends StatelessWidget {
  final String url;
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final BoxFit? boxFit;
  const CustomDisplayNetworkImage(
      {super.key,
      required this.url,
      required this.height,
      required this.width,
      this.boxFit,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.network(
          height: height,
          width: width,
          url,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.withValues(alpha: 0.2),
              height: height,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.broken_image_outlined)],
              ),
            );
          },
          fit: boxFit ?? BoxFit.contain,
        ),
      ),
    );
  }
}
