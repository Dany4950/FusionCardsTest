import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:vms/data/all_store_details_data_by_id.dart';
import 'package:vms/presentation/dashboard/stores/vm_stores.dart';
import 'package:vms/presentation/widgets/expansion_tile.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';

import '../../../common/colors.dart';
import '../../../controller/route_controller.dart';
import '../overview_cards.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  VMStores vmStores = Get.find();
  RouteController rc = Get.find();

  @override
  void initState() {
    super.initState();

    vmStores.pagingController.addPageRequestListener((pageKey) {
      vmStores.getStoreByStoreIdWithAllDetails(storeId: -1, page: pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        rc.popScreen();
      },
      child: Scaffold(
        appBar: MoksaNavBar(
          "Stores",
          isNeedBack: true,
          hideTrailing: true,
        ),
        backgroundColor: AppColors.white,
        body: PagedListView(
          pagingController: vmStores.pagingController,
          builderDelegate: PagedChildBuilderDelegate<AllStoreDetailsItem>(
            itemBuilder: (context, item, index) {
              return Column(
                children: [
                  if (index == 0) TopCards(),
                  StoreViewItem(item),
                  Gap(10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TopCards extends StatelessWidget {
  const TopCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OverviewCards(
            storeId: 33,
            titles: const [
              'Stores Assigned',
              'Cameras Assigned',
              "Customer Count",
              "Most Visited Aisle"
            ],
            isDashboardScreen: false,
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Text(
              'List of Stores',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class StoreViewItem extends StatelessWidget {
  final AllStoreDetailsItem store;

  const StoreViewItem(this.store, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: MoksaExpansionTile(
        title: store.name ?? 'No Name',
        subTitle: '${store.address}, ${store.country}, ${store.pincode}',
        leadingIcon: ClipOval(
          child: Image.asset(
            'assets/images/home.png',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        children: [
          Pair("Store Manager: ", store.manager ?? ""),
          Pair("No. of Cameras: ", store.cameraCount.toString()),
          Pair("Location: ",
              '${store.address}, ${store.country}, ${store.pincode}'),
          Pair('Time Zone:', store.timezone ?? ""),
          Pair("Has Kitchen: ", store.hasKitchen == true ? "Yes" : "No"),
          Pair("Is 24hrs Store: ", store.is24HrStore == true ? "Yes" : "No"),
        ],
      ),
    );
  }
}

class SpacedPairRow extends StatelessWidget {
  final Pair item;

  const SpacedPairRow({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            item.key,
            style: TextStyle(
              color: Colors.black.withAlpha(153),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 3,
          child: item.value is Widget
              ? item.value
              : Text(
                  item.value.toString(),
                  softWrap: true,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
        ),
      ],
    );
  }
}

class Pair {
  final String key;
  final dynamic value;

  Pair(this.key, this.value);
}
