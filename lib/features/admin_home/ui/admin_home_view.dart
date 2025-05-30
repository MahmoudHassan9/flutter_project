import 'package:flutter/material.dart';
import 'package:software_task/features/admin_home/ui/widgets/add_room_screen.dart';
import 'package:software_task/features/admin_home/ui/widgets/rooms_list_view.dart';
import 'package:software_task/features/auth/ui/login/view/login_view.dart';

import '../../../core/utils/app_colors.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rooms',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ),
              );
            },
            icon:const  Icon(
              Icons.logout,
              color: AppColors.white,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRoomScreen(),
            ),
          );
        },
        backgroundColor: AppColors.blue,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: RoomsListView(
          isAdmin: true,
        ),
      ),
    );
  }
}
