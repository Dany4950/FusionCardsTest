import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:vms/presentation/dashboard/heatmap/interactive_heatmap_screen.dart';
import 'package:vms/presentation/dashboard/heatmap/vm_heatmap.dart';

class Heatmap extends StatefulWidget {
  final int storeId;

  const Heatmap({
    super.key,
    required this.storeId,
  });

  @override
  _HeatmapState createState() => _HeatmapState();
}

class _HeatmapState extends State<Heatmap> {
  final VMHeatmap vmHeatmap = Get.find<VMHeatmap>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(Heatmap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.storeId != widget.storeId) {}
  }

  void _openInteractiveImage(String imageData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            InteractiveHeatmapScreen(imageData: imageData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Heatmap Image',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(15),
        // Container(
        //   decoration: BoxDecoration(
        //     border: Border.all(color: Colors.grey),
        //   ),
        //   child: Image.memory(
        //     base64Decode(ImageUrls.imageUrlBase64),
        //     fit: BoxFit.contain,
        //     errorBuilder: (context, error, stackTrace) {
        //       return const Text('Error loading image');
        //     },
        //   ),
        // )
        Obx(() {
          final isLoading = vmHeatmap.isLoadingHeatmap.value;
          final imageData = vmHeatmap.floormapBase64.value;

          if (isLoading) {
            return Container(
              height: 300.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (imageData.isEmpty) {
            return Container(
              height: 300.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(
                child: Text('No heatmap available'),
              ),
            );
          }

          return GestureDetector(
            onTap: () => _openInteractiveImage(imageData),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Image.memory(
                  base64Decode(imageData),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Error loading image');
                  },
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Heatmap Images',
  //         style: TextStyle(
  //           fontSize: 20.0,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const Gap(15),
  //       Obx(() {
  //         final isLoading = vmHeatmap.isLoadingHeatmap.value;
  //         final imagesDataList = vmHeatmap.floormapImagesDataList;

  //         if (isLoading) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }

  //         if (imagesDataList.isEmpty) {
  //           return const Center(
  //             child: Text('No heatmap available'),
  //           );
  //         }

  //         return GridView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: imagesDataList.length,
  //           gridDelegate:
  //               const SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             crossAxisSpacing: 10.0,
  //             mainAxisSpacing: 10.0,
  //           ),
  //           itemBuilder: (context, index) {
  //             final imageUrl = imagesDataList[index].imageUrl;

  //             return GestureDetector(
  //               onTap: () => _openInteractiveImage(imageUrl),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.grey),
  //                 ),
  //                 child: Image.memory(
  //                   base64Decode(imageUrl),
  //                   fit: BoxFit.contain,
  //                   errorBuilder: (context, error, stackTrace) {
  //                     return const Text('Error loading image');
  //                   },
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       }),
  //     ],
  //   );
  // }
}
