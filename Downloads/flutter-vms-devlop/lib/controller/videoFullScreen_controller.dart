// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class FullScreenController extends GetxController {
//   var isFullScreen = false.obs;

//   void toggleFullScreen() async {
//     if (isFullScreen.value) {
//       // Exit full screen
//       await SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//       ]);
//       await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     } else {
//       // Enter full screen
//       await SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeLeft,
//         DeviceOrientation.landscapeRight,
//       ]);
//       await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     }

//     isFullScreen.value = !isFullScreen.value;
//   }
// }
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FullScreenController extends GetxController {
  var isFullScreen = false.obs;

  void toggleFullScreen() async {
    if (isFullScreen.value) {
      // Exit full screen
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      // Enter full screen
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    isFullScreen.value = !isFullScreen.value;
  }
}
