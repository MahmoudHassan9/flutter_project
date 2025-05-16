import 'package:flutter/material.dart';
import 'package:software_task/features/admin_home/data/models/room_dm.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/app_syles.dart';
import '../../../auth/ui/widgets/custom_button.dart';
import '../../../auth/ui/widgets/title_and_text_form_field.dart';

class EditRoomScreen extends StatefulWidget {
  const EditRoomScreen({
    super.key,
    required this.roomDM,
  });

  final RoomDM roomDM;

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  late TextEditingController roomTitleController;
  late TextEditingController roomDescriptionController;
  late TextEditingController roomPriceController;
  late TextEditingController roomCapacityController;
  late TextEditingController roomIDController;

  @override
  void initState() {
    super.initState();
    roomTitleController = TextEditingController();
    roomDescriptionController = TextEditingController();
    roomPriceController = TextEditingController();
    roomCapacityController = TextEditingController();
    roomIDController = TextEditingController();
    
    // Initialize controllers with room data
    roomTitleController.text = widget.roomDM.name;
    roomDescriptionController.text = widget.roomDM.description;
    roomPriceController.text = widget.roomDM.price.toString();
    roomCapacityController.text = widget.roomDM.capacity.toString();
    roomIDController.text = widget.roomDM.id;
  }

  @override
  void dispose() {
    super.dispose();
    roomTitleController.dispose();
    roomDescriptionController.dispose();
    roomPriceController.dispose();
    roomCapacityController.dispose();
    roomIDController.dispose();
  }

  bool _hasChanges() {
    return roomTitleController.text != widget.roomDM.name ||
        roomDescriptionController.text != widget.roomDM.description ||
        double.parse(roomPriceController.text) != widget.roomDM.price ||
        int.parse(roomCapacityController.text) != widget.roomDM.capacity;
  }

  void _handleUpdateRoom() {
    if (!_hasChanges()) {
      AppDialogs.showMessage(
        context,
        message: 'No changes to update',
        color: Colors.orange,
      );
      return;
    }

    // Create updated room object
    final updatedRoom = RoomDM(
      id: roomIDController.text,
      name: roomTitleController.text,
      description: roomDescriptionController.text,
      price: double.parse(roomPriceController.text),
      capacity: int.parse(roomCapacityController.text),
      isAvailable: widget.roomDM.isAvailable,
    );

    // Update the room in the static list
    RoomDM.updateRoom(roomIDController.text, updatedRoom);

    Navigator.pop(context);
    AppDialogs.showMessage(
      context,
      message: 'Room updated successfully',
      color: Colors.green,
    );
  }

  void _handleDeleteRoom() {
    // Delete the room from the static list
    RoomDM.removeRoom(roomIDController.text);

    Navigator.pop(context);
    AppDialogs.showMessage(
      context,
      message: 'Room deleted successfully',
      color: Colors.red,
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
          'Edit Room',
          style: AppStyles.appBar,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TitleAndTextFormField(
                controller: roomIDController,
                enabled: false,
                title: 'Room ID',
                hint: 'Enter room ID',
                validator: (input) {
                  if (input == null || input.trim().isEmpty) {
                    return 'ID is required';
                  }
                  return null;
                },
              ),
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
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Update',
                      onPressed: _handleUpdateRoom,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: 'Delete',
                      color: Colors.red,
                      onPressed: _handleDeleteRoom,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
