import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/app_syles.dart';
import '../../../auth/ui/widgets/custom_button.dart';
import '../../../auth/ui/widgets/title_and_text_form_field.dart';
import '../../data/models/room_dm.dart';
import '../admin_home_view.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  late TextEditingController roomTitleController;
  late TextEditingController roomDescriptionController;
  late TextEditingController roomPriceController;
  late TextEditingController roomCapacityController;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    roomTitleController = TextEditingController();
    roomDescriptionController = TextEditingController();
    roomPriceController = TextEditingController();
    roomCapacityController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    roomTitleController.dispose();
    roomDescriptionController.dispose();
    roomPriceController.dispose();
    roomCapacityController.dispose();
  }

  void _handleAddRoom() {
    if (!formKey.currentState!.validate()) return;

    // Create a new room with the form data
    final newRoom = RoomDM(
      id: (RoomDM.rooms.length + 1).toString(), // Generate a new ID
      name: roomTitleController.text,
      description: roomDescriptionController.text,
      price: double.parse(roomPriceController.text),
      capacity: int.parse(roomCapacityController.text),
    );

    // Add the room to the static list
    RoomDM.addRoom(newRoom);

    // Show success message
    AppDialogs.showMessage(
      context,
      message: 'Room added successfully',
      color: Colors.green,
    );

    // Navigate back to AdminHomeView
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminHomeView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors.blue,
        centerTitle: true,
        title: Text(
          'Add Room',
          style: AppStyles.appBar,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TitleAndTextFormField(
                  controller: roomTitleController,
                  title: 'Room Name',
                  hint: 'Enter room name',
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Room name is required';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: roomDescriptionController,
                  title: 'Room Description',
                  hint: 'Enter room description',
                  maxLines: 7,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Room description is required';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: roomCapacityController,
                  title: 'Room Capacity',
                  hint: 'Enter number of persons',
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Room capacity is required';
                    }
                    if (int.tryParse(input) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: roomPriceController,
                  title: 'Room Price',
                  hint: 'Enter room price per night',
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Price is required';
                    }
                    if (double.tryParse(input) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  width: double.maxFinite,
                  child: CustomButton(
                    text: 'Add Room',
                    onPressed: _handleAddRoom,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
