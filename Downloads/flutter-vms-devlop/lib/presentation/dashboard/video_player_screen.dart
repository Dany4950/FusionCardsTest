// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:vms/common/colors.dart';
// import 'package:vms/manager/utils.dart';
// import 'package:vms/utils/util_functions.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerScreen({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool _isLoading = true;
//   String? _error;
//   late String widgetVideoUrl;

//   Future<void> _initializeVideo() async {
//     widgetVideoUrl = widget.videoUrl;

//     String? initialUrl =
//         SessionManager.prefs.getString(SessionManager.initialUrl);
//     if (initialUrl != null && initialUrl.isNotEmpty) {
//       widgetVideoUrl = initialUrl;
//       SessionManager.remove(SessionManager.initialUrl);
//     }

//     final presignedUrl = await getPresignedUrl(widgetVideoUrl);
//     if (presignedUrl == null) {
//       setState(() {
//         _error = 'Failed to get video URL';
//         _isLoading = false;
//       });
//       return;
//     }

//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(presignedUrl),
//     )..initialize().then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//         _controller.play();
//       }).catchError((error) {
//         setState(() {
//           _error = 'Failed to load video: $error';
//           _isLoading = false;
//         });
//       });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         title: const Text('Theft Video'),
//       ),
//       body: Center(
//         child: _error != null
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Sorry, Something went wrong",
//                       style: TextStyle(
//                         fontSize: 20,
//                       )),
//                   // try again
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isLoading = true;
//                         _error = null;
//                       });
//                       _initializeVideo();
//                     },
//                     child: const Text('Try Again'),
//                   ),

//                 ],
//               )
//             : _isLoading
//                 ? const CircularProgressIndicator()
//                 : AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: VideoPlayer(_controller),
//                   ),
//       ),
//       floatingActionButton: _error == null && !_isLoading
//           ? FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   _controller.value.isPlaying
//                       ? _controller.pause()
//                       : _controller.play();
//                 });
//               },
//               child: Icon(
//                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//               ),
//             )
//           : null,
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:video_player/video_player.dart';
// import 'package:vms/common/colors.dart';
// import 'package:vms/controller/videoFullScreen_controller.dart';
// import 'package:vms/manager/utils.dart';
// import 'package:vms/utils/util_functions.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerScreen({super.key, required this.videoUrl});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late FullScreenController fullScreenController;
//   bool _isLoading = true;
//   String? _error;
//   late String widgetVideoUrl;

//   Future<void> _initializeVideo() async {
//     widgetVideoUrl = widget.videoUrl;

//     String? initialUrl =
//         SessionManager.prefs.getString(SessionManager.initialUrl);
//     if (initialUrl != null && initialUrl.isNotEmpty) {
//       widgetVideoUrl = initialUrl;
//       SessionManager.remove(SessionManager.initialUrl);
//     }

//     final presignedUrl = await getPresignedUrl(widgetVideoUrl);
//     if (presignedUrl == null) {
//       setState(() {
//         _error = 'Failed to get video URL';
//         _isLoading = false;
//       });
//       return;
//     }

//     _controller = VideoPlayerController.networkUrl(
//       Uri.parse(presignedUrl),
//     )..initialize().then((_) {
//         setState(() {
//           _isLoading = false;
//         });
//         _controller.play();
//       }).catchError((error) {
//         setState(() {
//           _error = 'Failed to load video: $error';
//           _isLoading = false;
//         });
//       });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();

//     fullScreenController = Get.put(FullScreenController());
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   String _formatDuration(Duration duration) {
//     final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return "$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: AppColors.white,
//         appBar: AppBar(
//           backgroundColor: AppColors.white,
//           title: const Text('Theft Video'),
//         ),
//         body: Center(
//           child: _error != null
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Sorry, Something went wrong",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           _isLoading = true;
//                           _error = null;
//                         });
//                         _initializeVideo();
//                       },
//                       child: const Text('Try Again'),
//                     ),
//                   ],
//                 )
//               : _isLoading
//                   ? const CircularProgressIndicator()
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AspectRatio(
//                           aspectRatio: _controller.value.aspectRatio,
//                           child: VideoPlayer(_controller),
//                         ),
//                         const SizedBox(height: 10),
//                         // Progress bar
//                         ValueListenableBuilder(
//                           valueListenable: _controller,
//                           builder: (context, VideoPlayerValue value, child) {
//                             return Column(
//                               children: [
//                                 SliderTheme(
//                                   data: SliderTheme.of(context).copyWith(
//                                     trackHeight:
//                                         0.5, // 👈 Makes the slider bar thinner
//                                     thumbShape: const RoundSliderThumbShape(
//                                         enabledThumbRadius:
//                                             10), // 👈 Smaller thumb
//                                     overlayShape: const RoundSliderOverlayShape(
//                                         overlayRadius:
//                                             10), // 👈 Smaller tap circle
//                                   ),
//                                   child: Slider(
//                                     activeColor: const Color(0xFF00013A),
//                                     value: value.position.inSeconds.toDouble(),
//                                     max: value.duration.inSeconds.toDouble(),
//                                     onChanged: (newValue) {
//                                       _controller.seekTo(
//                                           Duration(seconds: newValue.toInt()));
//                                     },
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(_formatDuration(value.position)),
//                                       Text(_formatDuration(value.duration)),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         // Media controls
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             IconButton(
//                               icon: const Icon(
//                                   color: const Color(0xFF00013A),
//                                   Icons.fast_rewind,
//                                   size: 55),
//                               onPressed: () async {
//                                 final current =
//                                     await _controller.position ?? Duration.zero;
//                                 final target =
//                                     current - const Duration(seconds: 5);
//                                 _controller.seekTo(target > Duration.zero
//                                     ? target
//                                     : Duration.zero);
//                               },
//                             ),
//                             IconButton(
//                               icon: Icon(
//                                 color: const Color(0xFF00013A),
//                                 _controller.value.isPlaying
//                                     ? Icons.pause
//                                     : Icons.play_arrow,
//                                 size: 55,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _controller.value.isPlaying
//                                       ? _controller.pause()
//                                       : _controller.play();
//                                 });
//                               },
//                             ),
//                             IconButton(
//                               icon: const Icon(
//                                   color: const Color(0xFF00013A),
//                                   Icons.fast_forward,
//                                   size: 55),
//                               onPressed: () async {
//                                 final current =
//                                     await _controller.position ?? Duration.zero;
//                                 final total = _controller.value.duration;
//                                 final target =
//                                     current + const Duration(seconds: 5);
//                                 _controller
//                                     .seekTo(target < total ? target : total);
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//         ),
//         floatingActionButton: _error == null && !_isLoading
//             ? FloatingActionButton(
//                 onPressed: fullScreenController.toggleFullScreen)
//             : null);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/controller/videoFullScreen_controller.dart';
import 'package:vms/manager/utils.dart';
import 'package:vms/utils/util_functions.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late FullScreenController fullScreenController;
  bool _isLoading = true;
  String? _error;
  late String widgetVideoUrl;

  Future<void> _initializeVideo() async {
    widgetVideoUrl = widget.videoUrl;

    String? initialUrl =
        SessionManager.prefs.getString(SessionManager.initialUrl);
    if (initialUrl != null && initialUrl.isNotEmpty) {
      widgetVideoUrl = initialUrl;
      SessionManager.remove(SessionManager.initialUrl);
    }

    final presignedUrl = await getPresignedUrl(widgetVideoUrl);
    if (presignedUrl == null) {
      setState(() {
        _error = 'Failed to get video URL';
        _isLoading = false;
      });
      return;
    }

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(presignedUrl),
    )..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.play();
      }).catchError((error) {
        setState(() {
          _error = 'Failed to load video: $error';
          _isLoading = false;
        });
      });
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo();

    fullScreenController = Get.put(FullScreenController());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: AppColors.white,
          appBar: fullScreenController.isFullScreen.value
              ? null
              : AppBar(
                  backgroundColor: AppColors.white,
                  title: const Text('Theft Video'),
                ),
          body: SafeArea(
            child: Center(
              child: _error != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sorry, Something went wrong",
                          style: TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _error = null;
                            });
                            _initializeVideo();
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    )
                  : _isLoading
                      ? const CircularProgressIndicator()
                      : fullScreenController.isFullScreen.value
                          // Fullscreen video layout
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.black,
                              child: Stack(
                                children: [
                                  Center(
                                    child: AspectRatio(
                                      aspectRatio: _controller.value.aspectRatio,
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                                  // Floating controls in fullscreen
                                  Positioned(
                                    bottom: 20,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.fast_rewind,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            onPressed: () async {
                                              final current = await _controller.position ?? Duration.zero;
                                              final target = current - const Duration(seconds: 5);
                                              _controller.seekTo(target > Duration.zero ? target : Duration.zero);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.fast_forward,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            onPressed: () async {
                                              final current = await _controller.position ?? Duration.zero;
                                              final total = _controller.value.duration;
                                              final target = current + const Duration(seconds: 5);
                                              _controller.seekTo(target < total ? target : total);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          // Normal video layout
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                                const SizedBox(height: 10),
                                // Progress bar
                                ValueListenableBuilder(
                                  valueListenable: _controller,
                                  builder: (context, VideoPlayerValue value, child) {
                                    return Column(
                                      children: [
                                        SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            trackHeight: 0.5,
                                            thumbShape: const RoundSliderThumbShape(
                                                enabledThumbRadius: 10),
                                            overlayShape: const RoundSliderOverlayShape(
                                                overlayRadius: 10),
                                          ),
                                          child: Slider(
                                            activeColor: const Color(0xFF00013A),
                                            value: value.position.inSeconds.toDouble(),
                                            max: value.duration.inSeconds.toDouble(),
                                            onChanged: (newValue) {
                                              _controller.seekTo(
                                                  Duration(seconds: newValue.toInt()));
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(_formatDuration(value.position)),
                                              Text(_formatDuration(value.duration)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                // Media controls
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                          color: Color(0xFF00013A),
                                          Icons.fast_rewind,
                                          size: 55),
                                      onPressed: () async {
                                        final current =
                                            await _controller.position ?? Duration.zero;
                                        final target =
                                            current - const Duration(seconds: 5);
                                        _controller.seekTo(target > Duration.zero
                                            ? target
                                            : Duration.zero);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        color: const Color(0xFF00013A),
                                        _controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 55,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _controller.value.isPlaying
                                              ? _controller.pause()
                                              : _controller.play();
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                          color: Color(0xFF00013A),
                                          Icons.fast_forward,
                                          size: 55),
                                      onPressed: () async {
                                        final current =
                                            await _controller.position ?? Duration.zero;
                                        final total = _controller.value.duration;
                                        final target =
                                            current + const Duration(seconds: 5);
                                        _controller
                                            .seekTo(target < total ? target : total);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
            ),
          ),
          floatingActionButton: _error == null && !_isLoading
              ? FloatingActionButton(
                  onPressed: () {
                    fullScreenController.toggleFullScreen();
                  },
                  child: Icon(
                    fullScreenController.isFullScreen.value
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                  ),
                )
              : null,
        ));
  }
}