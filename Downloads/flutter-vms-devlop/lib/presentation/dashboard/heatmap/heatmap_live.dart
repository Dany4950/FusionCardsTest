import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vms/data/login_data.dart';
import 'package:vms/presentation/dashboard/heatmap/aisle_data.dart';
import 'package:vms/presentation/dashboard/heatmap/aisle_data_barchart.dart';
import 'package:vms/services/auth_service.dart';
import '../../../manager/api_manager/url.dart';
import 'vm_heatmap.dart';

class HeatmapLiveWidget extends StatefulWidget {
  final int storeId;

  const HeatmapLiveWidget(this.storeId, {Key? key}) : super(key: key);

  @override
  State<HeatmapLiveWidget> createState() => _HeatmapLiveWidgetState();
}

class _HeatmapLiveWidgetState extends State<HeatmapLiveWidget> {
  IO.Socket? socket;
  final VMHeatmap vmHeatmap = Get.find();
  final RxBool isConnected = false.obs;
  final RxBool isReconnecting = false.obs;
  int reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;

  @override
  void initState() {
    super.initState();
    debugPrint('HeatmapLiveWidget initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('Starting socket initialization...');
      await _fetchInitialData();
      _initializeSocket();
    });
  }

  Future<void> _fetchInitialData() async {
    try {
      await vmHeatmap.getLiveAisleDataByStoreId(widget.storeId);
    } catch (e) {
      debugPrint('Error fetching initial data: $e');
    }
  }

  void _initializeSocket() {
    final User? authData = AuthStorage.to.getUserData();
    if (authData == null) {
      debugPrint('Auth data missing');
      return;
    }

    try {
      // Cleanup any existing socket
      _cleanupSocket();

      // Initialize new socket with proper options
      socket = IO.io(
          BaseURL.socketBaseURL,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .enableReconnection()
              .setReconnectionAttempts(maxReconnectAttempts)
              .setReconnectionDelay(1000)
              .setReconnectionDelayMax(5000)
              .setTimeout(20000)
              .setExtraHeaders({
                'Authorization': 'Bearer ${AuthService().getToken()}'
              })
              .build());

      _setupSocketListeners(authData);
    } catch (e, stack) {
      debugPrint('Error initializing socket: $e\n$stack');
      _handleConnectionError();
    }
  }

  void _setupSocketListeners(User authData) {
    socket?.onConnect((_) {
      debugPrint('Socket Connected with ID: ${socket?.id}');
      isConnected.value = true;
      isReconnecting.value = false;
      reconnectAttempts = 0;

      // Join channels after successful connection
      _joinChannels(authData);
    });

    socket?.onConnectError((error) {
      debugPrint('Socket connection error: $error');
      _handleConnectionError();
    });

    socket?.onError((error) {
      debugPrint('Socket error: $error');
      _handleConnectionError();
    });

    socket?.onDisconnect((_) {
      debugPrint('Socket disconnected');
      isConnected.value = false;
      _handleDisconnect();
    });

    // Listen for aisle count updates
    final channel = 'aisle_count_store_${widget.storeId}';
    socket?.on(channel, (data) {
      debugPrint('📥 Received aisle data on $channel: $data');
      if (data != null) {
        _handleLiveData(data);
      }
    });
  }

  void _joinChannels(User authData) {
    try {
      socket?.emit('joinUser', authData.id);
      socket?.emit('joinStore', widget.storeId);
      debugPrint('✅ Joined channels successfully');
    } catch (e) {
      debugPrint('❌ Error joining channels: $e');
    }
  }

  void _handleConnectionError() {
    isConnected.value = false;
    if (!isReconnecting.value &&
        reconnectAttempts < maxReconnectAttempts) {
      _attemptReconnect();
    }
  }

  void _handleDisconnect() {
    if (!isReconnecting.value &&
        reconnectAttempts < maxReconnectAttempts) {
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    if (isReconnecting.value) return;

    isReconnecting.value = true;
    reconnectAttempts++;

    debugPrint(
        '🔄 Attempting reconnection (${reconnectAttempts}/$maxReconnectAttempts)...');
  }

  void _handleLiveData(dynamic data) {
    try {
      vmHeatmap.updateLiveData(data);
    } catch (e) {
      debugPrint('Error handling live data: $e');
    }
  }

  void _cleanupSocket() {
    if (socket != null) {
      try {
        socket?.disconnect();
        socket?.dispose();
        socket = null;
      } catch (e) {
        debugPrint('Error cleaning up socket: $e');
      }
    }
  }

  @override
  void dispose() {
    debugPrint('🧹 Cleaning up socket connection');
    _cleanupSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final liveData = vmHeatmap.liveStoreAisleData;

      if (liveData.isEmpty) {
        return const Center(child: Text('No live data available'));
      }
      return Column(
        children: [
          SizedBox(
            child: AisleDataBarChart(
                storeId: widget.storeId, isLive: true),
          ),
          SizedBox(
              child: AisleDataGrid(
                  storeId: widget.storeId, isLive: true)),
        ],
      );
    });
  }
}
