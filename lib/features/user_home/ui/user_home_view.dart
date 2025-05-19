import 'package:flutter/material.dart';
import 'package:software_task/features/user_home/ui/widgets/booking_list_tab.dart';
import 'package:software_task/features/user_home/ui/widgets/profile_tab.dart';
import 'package:software_task/features/user_home/ui/widgets/rooms_tab.dart';

class UserHomeView extends StatefulWidget {
  const UserHomeView({super.key});

  @override
  State<UserHomeView> createState() => _UserHomeViewState();
}

class _UserHomeViewState extends State<UserHomeView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    RoomsTab(),
    BookingListTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 
              ? 'Rooms' 
              : _selectedIndex == 1 
                  ? 'Booking List' 
                  : 'Profile',
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bed),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Booking List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
