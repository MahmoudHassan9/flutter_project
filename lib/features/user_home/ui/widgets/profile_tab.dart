import 'package:flutter/material.dart';
import 'package:software_task/features/auth/data/models/user_dm.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../auth/ui/login/view/login_view.dart';
import '../../../auth/ui/widgets/custom_button.dart';
import 'edit_profile_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  UserDM? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = UserDM.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Center(
        child: Text(
          'Please login to view your profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.blue,
            child: Icon(
              Icons.person,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.blue.withOpacity(0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfo('Full Name', currentUser!.fullName),
                  const Divider(),
                  _buildProfileInfo('Email', currentUser!.email),
                  const Divider(),
                  _buildProfileInfo('Phone', currentUser!.phoneNumber),
                  const Divider(),
                  _buildProfileInfo('Gender', currentUser!.gender),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "Edit Profile",
              color: AppColors.blue,
              onPressed: _editProfile,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: "Logout",
              color: AppColors.red,
              onPressed: _logout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value ?? 'Not provided',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: currentUser!),
      ),
    ).then((result) {
      // Refresh profile data if changes were made
      if (result == true) {
        setState(() {
          currentUser = UserDM.getCurrentUser();
        });
      }
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Clear current user email
              UserDM.currentUserEmail = null;
              // Navigate to login screen
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
