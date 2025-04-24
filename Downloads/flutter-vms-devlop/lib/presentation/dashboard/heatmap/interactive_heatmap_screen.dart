import 'dart:convert';

import 'package:flutter/material.dart';

class InteractiveHeatmapScreen extends StatelessWidget {
  final String imageData;

  const InteractiveHeatmapScreen({
    super.key,
    required this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    TransformationController controller = TransformationController();

    void handleDoubleTap() {
      controller.value = Matrix4.identity();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heatmap Image'),
      ),
      body: Center(
        child: GestureDetector(
          onDoubleTap: handleDoubleTap,
          child: ClipRect(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              boundaryMargin: EdgeInsets.zero,
              transformationController: controller,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Image.memory(
                  base64Decode(imageData),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Error loading image',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
