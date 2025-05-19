import 'package:flutter/material.dart';
import 'package:software_task/core/utils/extensions/validate_ex.dart';
import 'package:software_task/features/auth/data/models/user_dm.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../../../core/utils/app_syles.dart';
import '../../../auth/ui/widgets/title_and_text_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  final UserDM user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  String? selectedGender;
  GlobalKey<FormState> formKey = GlobalKey();

  // Track changed fields
  bool isFullNameChanged = false;
  bool isPhoneNumberChanged = false;
  bool isEmailChanged = false;
  bool isGenderChanged = false;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController(text: widget.user.fullName);
    phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
    emailController = TextEditingController(text: widget.user.email);
    selectedGender = widget.user.gender;

    // Add listeners to detect changes
    fullNameController.addListener(() {
      setState(() {
        isFullNameChanged = fullNameController.text != widget.user.fullName;
      });
    });

    phoneNumberController.addListener(() {
      setState(() {
        isPhoneNumberChanged =
            phoneNumberController.text != widget.user.phoneNumber;
      });
    });

    emailController.addListener(() {
      setState(() {
        isEmailChanged = emailController.text != widget.user.email;
      });
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!formKey.currentState!.validate()) return;

    // Check if anything has changed
    bool hasChanges = isFullNameChanged ||
        isPhoneNumberChanged ||
        isEmailChanged ||
        isGenderChanged;

    if (!hasChanges) {
      AppDialogs.showMessage(
        context,
        message: 'No changes to save',
        color: Colors.orange,
      );
      return;
    }

    // Check if email already exists for other users
    final isEmailExistForOthers = UserDM.users.any((user) =>
        user.email == emailController.text && user.id != widget.user.id);

    if (isEmailExistForOthers) {
      AppDialogs.showMessage(
        context,
        message: 'Email already exists',
        color: Colors.red,
      );
      return;
    }

    // Create updated user
    final updatedUser = UserDM(
      id: widget.user.id,
      fullName: fullNameController.text,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
      password: widget.user.password,
      gender: selectedGender!,
    );

    // Update user in static list
    UserDM.updateUser(updatedUser);

    // Update current user email if it has changed
    if (widget.user.email != emailController.text) {
      UserDM.currentUserEmail = emailController.text;
    }

    // Show success message
    AppDialogs.showMessage(
      context,
      message: 'Profile updated successfully',
      color: Colors.green,
    );

    // Navigate back
    Navigator.pop(context, true);
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
          'Edit Profile',
          style: AppStyles.appBar,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.blue,
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TitleAndTextFormField(
                  controller: fullNameController,
                  title: 'Full Name',
                  hint: 'Enter your full name',
                  filledColor:
                      isFullNameChanged ? Colors.blue.withOpacity(0.1) : null,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    if (input.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: phoneNumberController,
                  title: 'Phone Number',
                  hint: 'Enter your phone number',
                  filledColor: isPhoneNumberChanged
                      ? Colors.blue.withOpacity(0.1)
                      : null,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (input.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                TitleAndTextFormField(
                  controller: emailController,
                  title: 'Email',
                  hint: 'Enter your email',
                  filledColor:
                      isEmailChanged ? Colors.blue.withOpacity(0.1) : null,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!input.validate) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: AppStyles.settingsTabLabel.copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: isGenderChanged
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Male'),
                              value: 'Male',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                  isGenderChanged = value != widget.user.gender;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Female'),
                              value: 'Female',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                  isGenderChanged = value != widget.user.gender;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      disabledForegroundColor: Colors.grey,
                    ),
                    onPressed: _saveProfile,
                    child: const Text('Save'),
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
