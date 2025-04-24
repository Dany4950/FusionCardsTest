import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:vms/manager/utils.dart';
import 'package:vms/presentation/dashboard/theft/theft_item_card.dart';
import 'package:vms/presentation/dashboard/theft/theft_trends_widget.dart';
import 'package:vms/presentation/dashboard/theft/thefts_chart.dart';
import 'package:vms/presentation/dashboard/theft/vm_theft.dart';
import 'package:vms/presentation/widgets/date_range_selector.dart';
import 'package:vms/services/auth_service.dart';
import 'package:vms/utils/widgets/common_widget.dart';

import '../../../data/login_data.dart';
import '../../../data/theft/thefts_list_data.dart';
import '../../../manager/api_manager/url.dart';
import '../people_count/people_count_live.dart';

class TheftLiveWidget extends StatefulWidget {
  const TheftLiveWidget({super.key});

  @override
  State<TheftLiveWidget> createState() =>
      _TheftLiveWidgetWidgetState();
}

class _TheftLiveWidgetWidgetState extends State<TheftLiveWidget> {
  io.Socket? socket;
  VMTheft vmTheft = Get.find();

  Future<bool> _fetchInitialData() async {
    bool isDone = await vmTheft.getLiveTheftListByStoreId(
      storeId: -1,
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
    if (authData != null) {
      List<TheftsListItem> uniqueItems = vmTheft.liveTheftDataList
          .fold<Map<int, TheftsListItem>>({}, (map, item) {
            map[item.storeId] = item;
            return map;
          })
          .values
          .toList();

      socket = io.io(BaseURL.socketBaseURL, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket?.onConnect((_) {
        debugPrint('Connected to server');
        socket?.emit('joinUser', authData.id);
        debugPrint("JoinedUser ${authData.id}");

        for (var item in uniqueItems) {
          socket?.emit('joinStore', item.storeId);
          debugPrint("JoinedStore ${item.storeId}");
        }
      });

      // Always listen to user notifications
      socket?.on('notification_${authData.id}', (data) {
        debugPrint('Theft Notification: $data');
      });

      // Listen only to the people count event

      for (var item in uniqueItems) {
        socket?.on('theft_store_${item.storeId}', (data) {
          handleNormalUserData(data);
        });
        debugPrint("ListeningStore ${item.storeId}");
      }
    }

    socket
        ?.onDisconnect((_) => debugPrint('Disconnected from server'));
  }

  handleNormalUserData(data) {
    debugPrint(data.toString());
    TheftsListItem newData =
        TheftsListItem.fromJson(customDecoder(data));
    vmTheft.liveTheftDataList.insert(0, newData);
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
      builder:
          (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return Obx(() {
            debugPrint(
                "Building ListView with ${vmTheft.liveTheftDataList.length} items");

            if (vmTheft.liveTheftDataList.isEmpty) {
              return Center(
                  child: getText("No Thefts Detected Today!"));
            }

            return ListView(
              children: [
                // Add the graphs from history screen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(8),
                      TheftsDetectedChart(
                        storeId: '-1',
                        key: ValueKey('live'),
                        range: DateRangeType.lastWeek,
                      ),
                      Gap(15),
                      TheftTrendsWidget(
                        storeId: '-1',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Live Thefts',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                // List of theft items
                ...vmTheft.liveTheftDataList
                    .map((storeData) => TheftItemCard(storeData))
                    .toList(),
              ],
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
