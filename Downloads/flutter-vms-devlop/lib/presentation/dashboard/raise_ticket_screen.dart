import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/presentation/dashboard/support_screen.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';

import '../../controller/route_controller.dart';

class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});

  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  String? selectedStore;
  String? selectedCamera;
  final TextEditingController issueController = TextEditingController();
  RouteController rc = Get.find();

  @override
  void dispose() {
    issueController.dispose();
    super.dispose();
  }

  void _handleCancel() {
    rc.pushScreen(SupportScreen());
  }

  void _handleSubmit() {
    if (selectedStore != null &&
        selectedCamera != null &&
        issueController.text.isNotEmpty) {
      // Submit ticket logic here

      rc.pushScreen(SupportScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        rc.popScreen();
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: MoksaNavBar(
          "Raise a Ticket",
          isNeedBack: true,
          hideTrailing: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Store Dropdown
              DropdownButtonFormField<String>(
                value: selectedStore,
                decoration: const InputDecoration(
                  labelText: 'Select Store',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'store1', child: Text('Store 1')),
                  DropdownMenuItem(value: 'store2', child: Text('Store 2')),
                  // Add more stores as needed
                ],
                onChanged: (value) {
                  setState(() {
                    selectedStore = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Camera Dropdown
              DropdownButtonFormField<String>(
                value: selectedCamera,
                decoration: const InputDecoration(
                  labelText: 'Select Camera',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'camera1', child: Text('Camera 1')),
                  DropdownMenuItem(value: 'camera2', child: Text('Camera 2')),
                  // Add more cameras as needed
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCamera = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Issue TextField
              TextField(
                controller: issueController,
                decoration: const InputDecoration(
                  labelText: 'Describe the Issue',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _handleCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
