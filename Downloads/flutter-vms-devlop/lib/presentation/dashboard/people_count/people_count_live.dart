import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:vms/data/people_count/people_count_live_response.dart';
import 'package:vms/manager/utils.dart';
import 'package:vms/presentation/dashboard/people_count/busy_hour_projection_chart.dart';
import 'package:vms/presentation/dashboard/people_count/vm_people_count.dart';
import 'package:vms/presentation/dashboard/stores/stores_screen.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/presentation/widgets/expansion_tile.dart';
import 'package:vms/services/auth_service.dart';
import 'package:vms/utils/widgets/common_widget.dart';

import '../../../data/login_data.dart';
import '../../../manager/api_manager/url.dart';

Map<String, dynamic> customDecoder(data) {
  Map<String, dynamic> jsonData;

  if (data is String) {
    jsonData = jsonDecode(data);
  } else if (data is Map) {
    jsonData = Map<String, dynamic>.from(data);
  } else {
    jsonData = {};
  }
  return jsonData;
}

class PeopleCountLiveWidget extends StatefulWidget {
  @override
  State<PeopleCountLiveWidget> createState() => _PeopleCountLiveWidgetState();
}

class _PeopleCountLiveWidgetState extends State<PeopleCountLiveWidget> {
  IO.Socket? socket;

  final VMPeopleCount vmPeopleCount = Get.find<VMPeopleCount>();

  Future<bool> _fetchInitialData() async {
    bool isDone = await vmPeopleCount.getPeopleCountLive(
      storeId: -1,
      page: 1,
    );

    if (isDone) {
      _connectToWebSocket();
    } else {
      showToast('Failed to load data - to connected to websocket');
    }
    return isDone;
  }

  void _connectToWebSocket() {
    User? authData = AuthStorage.to.getUserData();
    String superAdminId = "-1";
    if (authData != null) {
      socket = IO.io(BaseURL.socketBaseURL, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket?.onConnect((_) {
        debugPrint('Connected to server');
        socket?.emit('joinUser', authData.id);
        if (authData.isSuperAdmin) {
          socket?.emit('joinStore', superAdminId);
          debugPrint("SuperAdminJoined");
        } else {
          for (var item in vmPeopleCount.liveStoreDataList) {
            socket?.emit('joinStore', item.storeId);
            debugPrint("JoinedStore ${item.storeId}");
          }
        }
      });

      // Always listen to user notifications
      socket?.on('notification_${authData.id}', (data) {
        debugPrint('People Count Notification: $data');
      });

      // Listen only to the people count event
      if (authData.isSuperAdmin) {
        socket?.on('people_count_store_$superAdminId', (data) {
          handleSuperAdminData(data);
        });
        debugPrint("ListeningSuperAdmin");
      } else {
        for (var item in vmPeopleCount.liveStoreDataList) {
          socket?.on('people_count_store_${item.storeId}', (data) {
            handleNormalUserData(data);
          });
          debugPrint("ListeningStore ${item.storeId}");
        }
      }
    }

    socket?.onDisconnect((_) => debugPrint('Disconnected from server'));
  }

  handleSuperAdminData(data) {
    debugPrint(data.toString());
    StorePeopleCountItem newData =
        StorePeopleCountItem.fromJson(customDecoder(data));
    int index = vmPeopleCount.liveStoreDataList
        .indexWhere((element) => element.storeId == newData.storeId);
    if (index != -1) {
      vmPeopleCount.liveStoreDataList[index] = newData;
    } else {
      vmPeopleCount.liveStoreDataList.add(newData);
    }
  }

  handleNormalUserData(data) {
    debugPrint(data.toString());
    StorePeopleCountItem newData =
        StorePeopleCountItem.fromJson(customDecoder(data));
    int index = vmPeopleCount.liveStoreDataList
        .indexWhere((element) => element.storeId == newData.storeId);
    if (index != -1) {
      vmPeopleCount.liveStoreDataList[index] = newData;
    }
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
            if (vmPeopleCount.liveStoreDataList.isEmpty) {
              return Center(child: getText("No Data Found!"));
            }

            return ListView.separated(
              itemCount: vmPeopleCount.liveStoreDataList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final storeData = vmPeopleCount.liveStoreDataList[index];
                return PeopleCountCard(storeData);
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

class VMLivePeopleCount extends GetxController {
  final liveStoreDataList = <StorePeopleCountItem>[].obs;
}

class PeopleCountCard extends StatelessWidget {
  final StorePeopleCountItem store;
  final Color chartBarColor;
  final Color chartBusyHourColor;

  const PeopleCountCard(
    this.store, {
    super.key,
    this.chartBarColor = const Color(0xFF4285F4),
    this.chartBusyHourColor = const Color(0xFFEA4335),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: MoksaExpansionTile(
        title: store.store ?? 'Unknown Store',
        subTitle: 'Total Count: ${store.noofcustomers}',
        leadingIcon: Image.asset(
          "assets/images/home.png",
        ),
        children: [
          Pair(
            "Busy Hour Projections",
            (store.busyhour != null && store.busyhour!.isNotEmpty)
                ? store.busyhour!
                : "Nil",
          ),
          Pair(
            "Customer Projection",
            "${store.predictedmean ?? ''}",
          ),
        ],
        chartWidget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: BusyHourProjectionChart(
              storeId: store.storeId.toString(),
              barColor: chartBarColor,
              busyHourColor: chartBusyHourColor,
              type: DateRangeType.today,
            ),
          ),
        ),
      ),
    );
  }
}
