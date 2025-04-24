import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vms/common/colors.dart';
import 'package:vms/data/user_details.dart';
import 'package:vms/presentation/profile/vm_profile.dart';
import 'package:vms/presentation/widgets/moksa_nav_bar.dart';
import 'package:vms/services/auth_service.dart';
import 'package:vms/utils/components/primary_button.dart';

import '../../controller/route_controller.dart';
import '../dashboard/support_screen.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final TextEditingController accountEmailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  Future<PUserData?>? _userFuture;
  int? userId;

  bool isAccountEmailEditing = false;
  bool isPhoneNumberEditing = false;
  bool isEditingProfile = false;

  VMProfile vmProfile = Get.find();
  RouteController rc = Get.find();

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUserData();
  }

  Future<PUserData?> _loadUserData() async {
    final authService = AuthService();
    userId = authService.getUserId();
    if (userId != null) {
      return await vmProfile.getUserByUserId(userId!);
    }
    return null;
  }

  @override
  void dispose() {
    accountEmailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        rc.popScreen();
      },
      child: Scaffold(
        appBar: const MoksaNavBar(
          "Profile",
          isNeedBack: true,
          hideTrailing: true,
        ),
        backgroundColor: AppColors.white,
        body: FutureBuilder<PUserData?>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data != null) {
                final user = snapshot.data!;
                accountEmailController.text = user.email ?? "";
                phoneNumberController.text = user.mobileNumber ?? "";

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileCard(user: user),
                        const SizedBox(height: 24.0),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.profilecardbg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Account Email Field
                                TextField(
                                  controller: accountEmailController,
                                  readOnly: !isEditingProfile,
                                  decoration: InputDecoration(
                                    labelText: 'Account Email',
                                    suffixIcon: isEditingProfile
                                        ? IconButton(
                                            icon: Icon(isAccountEmailEditing
                                                ? Icons.check
                                                : Icons.edit),
                                            onPressed: () {
                                              setState(() {
                                                isAccountEmailEditing =
                                                    !isAccountEmailEditing;
                                              });
                                            },
                                          )
                                        : null,
                                  ),
                                ),
                                // const Divider(),
                                // Password Field
                                if (isEditingProfile)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text('Password: ••••••••'),
                                    trailing: TextButton(
                                      onPressed: () {
                                        // Implement change password logic
                                      },
                                      child: const Text('Change Password'),
                                    ),
                                  ),
                                // const Divider(),
                                // Phone Number Field
                                TextField(
                                  controller: phoneNumberController,
                                  readOnly: !isEditingProfile,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    suffixIcon: isEditingProfile
                                        ? IconButton(
                                            icon: Icon(isPhoneNumberEditing
                                                ? Icons.check
                                                : Icons.edit),
                                            onPressed: () {
                                              setState(() {
                                                isPhoneNumberEditing =
                                                    !isPhoneNumberEditing;
                                              });
                                            },
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        // Help section
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Need help?',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Need help with account settings? Our developers are ready to assist!',
                                          maxLines: 3,
                                        ),
                                      ),
                                      Image.asset(
                                          "assets/images/profile_helpimage.png"),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  TextField(
                                    controller: vmProfile.helpQueryController,
                                    decoration: InputDecoration(
                                      hintText: 'Send your queries to us...',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    maxLines: 4,
                                  ),
                                  const SizedBox(height: 16.0),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (vmProfile.createHelpLM.canRun) {
                                          vmProfile.createHelpRequest();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      child: Obx(
                                        () => vmProfile
                                                .createHelpLM.isLoading.value
                                            ? const CircularProgressIndicator()
                                            : const Text(
                                                'Submit',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        // Support and Logout buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CustomPrimaryButton(
                                buttonColor: Colors.red,
                                textValue: 'Logout',
                                textColor: Colors.white,
                                onPressed: () async {
                                  final authService = AuthService();
                                  await authService.logout();
                                },
                              ),
                            ),
                            if (isEditingProfile) const SizedBox(width: 16.0),
                            if (isEditingProfile)
                              Expanded(
                                child: CustomPrimaryButton(
                                  buttonColor: Colors.blue,
                                  textValue: 'Support',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    rc.pushScreen(SupportScreen());
                                  },
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(child: Text('Failed to load user data'));
              }
            }),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.user,
  });

  final PUserData user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.profilecardbg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                "User ID : ${user.id}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Column(
                children: [
                  const ProfileImage(),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      user.role ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/profile_sample.png'),
        ),
        // Positioned(
        //   bottom: 0,
        //   right: 0,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.white,
        //     child: IconButton(
        //       icon: Icon(Icons.camera_alt),
        //       onPressed: null,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
