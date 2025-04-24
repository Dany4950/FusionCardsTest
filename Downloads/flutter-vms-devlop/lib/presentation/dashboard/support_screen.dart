import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/presentation/dashboard/raise_ticket_screen.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';

import '../../controller/route_controller.dart';

class SupportScreen extends StatelessWidget {
  final RouteController rc = Get.find();

  SupportScreen({super.key});

  void _launchPhone() async {
    final Uri phoneUri = Uri.parse('tel:+1313749832');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _launchEmail() async {
    final Uri emailUri = Uri.parse('mailto:info@moksa.ai');
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _showTicketsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * 0.5, // 50% of screen height
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Tickets',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              // Ticket List
              Expanded(
                child: ListView.builder(
                  itemCount: 3, // Replace with actual tickets list
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.confirmation_number),
                        title: Text('Ticket #${index + 1}'),
                        subtitle: const Text('Pending'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Handle ticket selection
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
        appBar: const MoksaNavBar(
          "Support",
          isNeedBack: true,
          hideTrailing: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Icon(
                  Icons.support_agent,
                  size: 100,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                const Text(
                  'How can we help you?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Have a question? Ask or search here...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Contact Options
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('+1 313-749-8832'),
                          onTap: _launchPhone,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text('info@moksa.ai'),
                          onTap: _launchEmail,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Support Options Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildSupportCard(
                      context,
                      'My Tickets',
                      Icons.confirmation_number,
                      () => _showTicketsBottomSheet(context),
                    ),
                    _buildSupportCard(
                      context,
                      'Raise a Ticket',
                      Icons.add_circle_outline,
                      () {
                        rc.pushScreen(const RaiseTicketScreen());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
