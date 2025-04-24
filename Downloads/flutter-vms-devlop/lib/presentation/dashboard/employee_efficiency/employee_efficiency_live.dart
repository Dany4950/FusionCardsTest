import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vms/presentation/dashboard/employee_efficiency/vm_employee_efficiency.dart';
import 'package:vms/services/auth_service.dart';
import 'package:vms/utils/widgets/common_widget.dart';

import '../../../data/employee_efficiency_details.dart';
import '../../../data/login_data.dart';
import '../../../manager/api_manager/url.dart';
import '../people_count/people_count_live.dart';
import 'employee_efficiency_screen.dart';

class EmployeeEfficiencyLiveWidget extends StatefulWidget {
  final int storeId;
  final bool isForDashboard;

  const EmployeeEfficiencyLiveWidget(this.storeId,
      {super.key, this.isForDashboard = false});

  @override
  State<EmployeeEfficiencyLiveWidget> createState() =>
      _EmployeeEfficiencyLiveWidgetState();
}

class _EmployeeEfficiencyLiveWidgetState
    extends State<EmployeeEfficiencyLiveWidget> {
  IO.Socket? socket;
  VMEmployeeEfficiency vmEmployeeEfficiency = Get.find();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Set up pagination controller first
    _setupPaginationController();
    // Connect to WebSocket as soon as possible
    _connectToWebSocket();
  }

  void _setupPaginationController() {
    // Clear any existing listeners
    vmEmployeeEfficiency.livePagingController.removePageRequestListener((_) {});

    // Set up the page request listener
    vmEmployeeEfficiency.livePagingController.addPageRequestListener((pageKey) {
      vmEmployeeEfficiency.getPagedLiveEmployeeEfficiencyByStoreid(
          widget.storeId, pageKey);
    });

    // Ensure the controller is ready for first page
    if (vmEmployeeEfficiency.livePagingController.nextPageKey == null) {
      vmEmployeeEfficiency.livePagingController.nextPageKey = 0;
    }

    // Request first page
    vmEmployeeEfficiency.livePagingController.refresh();

    // Mark loading as complete after a short delay to allow the first page to load
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
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

      socket?.on('notification_${authData.id}', (data) {
        debugPrint('Employee Efficiency Notification: $data');
      });

      socket?.on('employee_efficiency_store_${widget.storeId}', (data) {
        handleNormalUserData(data);
      });
      debugPrint("ListeningStore ${widget.storeId}");
    }

    socket?.onDisconnect((_) => debugPrint('Disconnected from server'));
  }

  handleNormalUserData(data) {
    // Process the incoming socket data
    EmployeeEfficiencySocketData newData =
        EmployeeEfficiencySocketData.fromJson(customDecoder(data));

    vmEmployeeEfficiency.liveEmpEff
        .insert(0, newData.toEmployeeEfficiencyItemData());

    if (vmEmployeeEfficiency.livePagingController.itemList != null) {
      List<EmployeeEfficiencyItemData> currentItems =
          List.from(vmEmployeeEfficiency.livePagingController.itemList ?? []);
      currentItems.insert(0, newData.toEmployeeEfficiencyItemData());

      if (currentItems.length > 100) {
        currentItems = currentItems.sublist(0, 100);
      }

      vmEmployeeEfficiency.livePagingController.itemList = currentItems;
    }
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return PagedListView<int, EmployeeEfficiencyItemData>(
      pagingController: vmEmployeeEfficiency.livePagingController,
      // Never scrollable
      physics: widget.isForDashboard
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      shrinkWrap: widget.isForDashboard,
      builderDelegate: PagedChildBuilderDelegate<EmployeeEfficiencyItemData>(
        itemBuilder: (context, item, index) {
          return EmployeeCard(item, isLive: true);
        },
        noItemsFoundIndicatorBuilder: (_) =>
            Center(child: getText("No Data Found!")),
        firstPageErrorIndicatorBuilder: (context) =>
            Center(child: getText("Error loading data")),
        newPageProgressIndicatorBuilder: (_) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}
