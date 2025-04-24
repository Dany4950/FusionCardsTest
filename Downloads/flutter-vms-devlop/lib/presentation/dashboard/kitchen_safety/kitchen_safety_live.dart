import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vms/manager/utils.dart';
import 'package:vms/presentation/dashboard/kitchen_safety/kitchen_safety_screen.dart';
import 'package:vms/presentation/dashboard/kitchen_safety/vm_kitchen_safety.dart';
import 'package:vms/services/auth_service.dart';
import 'package:vms/utils/widgets/common_widget.dart';

import '../../../data/kitchen_safety_data.dart';
import '../../../data/login_data.dart';
import '../../../manager/api_manager/url.dart';
import '../people_count/people_count_live.dart';

class KitchenSafetyLiveWidget extends StatefulWidget {
  final int storeId;
  final bool isFromDashboard;

  KitchenSafetyLiveWidget(this.storeId, {this.isFromDashboard = false});

  @override
  State<KitchenSafetyLiveWidget> createState() =>
      _KitchenSafetyLiveWidgetState();
}

class _KitchenSafetyLiveWidgetState extends State<KitchenSafetyLiveWidget> {
  IO.Socket? socket;
  VMKitchenSafety vmKitchenSafety = Get.find();

  Future<bool> _fetchInitialData() async {
    bool isDone = await vmKitchenSafety
        .getLiveKitchenSafetyDetailsOfAllEmployees(widget.storeId);

    if (isDone) {
      _connectToWebSocket();
    } else {
      showToast('Failed to load data - to connected to websocket');
    }
    return isDone;
  }

  void _connectToWebSocket() {
    User? authData = AuthStorage.to.getUserData();
    if (authData != null) {
      socket = IO.io(BaseURL.socketBaseURL, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket?.onConnect((_) {
        debugPrint('Connected to server');
        socket?.emit('joinUser', authData.id);
        debugPrint("JoinedUser ${authData.id}");

        socket?.emit('joinStore', widget.storeId);
        debugPrint("JoinedStore ${widget.storeId}");
      });

      // Always listen to user notifications
      socket?.on('notification_${authData.id}', (data) {
        debugPrint('Kitchen Notification: $data');
      });

      // Listen only to the people count event

      socket?.on('employee_safety_store_${widget.storeId}', (data) {
        handleNormalUserData(data);
      });
      debugPrint("ListeningStore ${widget.storeId}");
    }

    socket?.onDisconnect((_) => debugPrint('Disconnected from server'));
  }

  handleNormalUserData(data) {
    KsEmployeeData newData = KsEmployeeData.fromJson(customDecoder(data));
    vmKitchenSafety.liveKitSafe.insert(0, newData);
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchInitialData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return Obx(() {
            if (vmKitchenSafety.liveKitSafe.isEmpty) {
              return Center(child: getText("No Data Found!"));
            }
            return ListView.builder(
              padding: EdgeInsets.only(top: 8),
              itemCount: vmKitchenSafety.liveKitSafe.length,
              shrinkWrap: widget.isFromDashboard,
              physics: widget.isFromDashboard
                  ? NeverScrollableScrollPhysics()
                  : null,
              itemBuilder: (context, index) {
                final employeeData = vmKitchenSafety.liveKitSafe[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: KSafetyCard(employeeData),
                );
              },
            );
          });
        } else {
          return Center(
            child: getText(snapshot.error.toString()),
          );
        }
      },
    );
  }
}
