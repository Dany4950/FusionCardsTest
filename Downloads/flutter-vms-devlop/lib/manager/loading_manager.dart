import 'package:get/get.dart';

class LoadingManager {
  RxBool isLoading = RxBool(false);

  showLoading() async {
    isLoading.value = true;
  }

  hideLoading() {
    isLoading.value = false;
  }

  bool get canRun {
    return isLoading.value == false;
  }
}

// class LoadingManager {
//   static final shared = LoadingManager();
//   OverlayEntry? entry;
//
//   OverlayEntry loadingOverlayEntry() {
//     return OverlayEntry(builder: (BuildContext context) {
//       return Container(
//         color: Colors.black.withOpacity(0.5),
//         child: Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//       );
//     });
//   }
//
//   showLoading() async {
//     await Future.delayed(Duration.zero);
//     final state = Overlay.of(Get.overlayContext!);
//     if (entry == null) {
//       entry = loadingOverlayEntry();
//       state.insert(entry!);
//     }
//   }
//
//   hideLoading() {
//     if (entry != null) {
//       entry?.remove();
//       entry = null;
//     }
//   }
// }
