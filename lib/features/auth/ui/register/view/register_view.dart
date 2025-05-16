import 'package:flutter/material.dart';
import 'package:software_task/core/utils/extensions/validate_ex.dart';
import 'package:software_task/features/auth/data/models/user_dm.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dialogs.dart';
import '../../../../../core/utils/app_syles.dart';
import '../../login/view/login_view.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/title_and_text_form_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController fullNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  String? selectedGender;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void _handleRegister() {
    if (!formKey.currentState!.validate()) return;
    if (selectedGender == null) {
      AppDialogs.showMessage(
        context,
        message: 'Please select your gender',
        color: Colors.red,
      );
      return;
    }

    // Check if email already exists
    if (UserDM.isEmailExists(emailController.text)) {
      AppDialogs.showMessage(
        context,
        message: 'Email already exists',
        color: Colors.red,
      );
      return;
    }

    // Create new user
    final newUser = UserDM(
      id: (UserDM.users.length + 1).toString(),
      fullName: fullNameController.text,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
      password: passwordController.text,
      gender: selectedGender!,
    );

    // Add user to static list
    UserDM.addUser(newUser);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginView(),
      ),
    );
    AppDialogs.showMessage(
      context,
      message: 'Registered Successfully',
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register',
                    style: AppStyles.settingsTabLabel.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TitleAndTextFormField(
                    controller: fullNameController,
                    title: 'Full Name',
                    hint: 'Enter your full name',
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return 'full name is required';
                      }
                      if (input.length < 3) {
                        return 'name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                  TitleAndTextFormField(
                    controller: phoneNumberController,
                    title: 'Phone Number',
                    hint: 'Enter your phone number',
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return 'phone number is required';
                      }
                      if (input.length < 10) {
                        return 'please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  TitleAndTextFormField(
                    controller: emailController,
                    title: 'Email',
                    hint: 'Enter your email',
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return 'email is required';
                      }
                      if (!input.validate) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  TitleAndTextFormField(
                    controller: passwordController,
                    title: 'Password',
                    hint: 'Enter your password',
                    isObscure: true,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return 'password is required';
                      }
                      if (input.length < 6) {
                        return 'password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  TitleAndTextFormField(
                    controller: confirmPasswordController,
                    title: 'Confirm Password',
                    hint: 'Confirm your password',
                    isObscure: true,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return 'confirm password is required';
                      }
                      if (input != passwordController.text) {
                        return 'passwords do not match';
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
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Male'),
                              value: 'Male',
                              groupValue: selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
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
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: CustomButton(
                      text: 'Register',
                      onPressed: _handleRegister,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account ?',
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginView(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: AppStyles.settingsTabLabel.copyWith(
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
