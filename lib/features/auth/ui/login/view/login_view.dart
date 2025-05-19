import 'package:flutter/material.dart';
import 'package:software_task/core/constants/constants.dart';
import 'package:software_task/core/utils/extensions/validate_ex.dart';
import 'package:software_task/features/admin_home/ui/admin_home_view.dart';
import 'package:software_task/features/auth/data/models/user_dm.dart';
import 'package:software_task/features/auth/ui/register/view/register_view.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_dialogs.dart';
import '../../../../../core/utils/app_syles.dart';
import '../../../../user_home/ui/user_home_view.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/title_and_text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void _handleLogin() {
    if (!formKey.currentState!.validate()) return;
    // Check user credentials
    final user = UserDM.findUser(emailController.text, passwordController.text);

    if (user != null) {
      if (user.email == AppConstants.adminEmail &&
          user.password == AppConstants.adminPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminHomeView(),
          ),
        );
      }
      else {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserHomeView(),
        ),
      );
      }
      AppDialogs.showMessage(
        context,
        message: 'Welcome back, ${user.fullName}!',
        color: Colors.green,
      );
    } else {
      AppDialogs.showMessage(
        context,
        message: 'Invalid email or password',
        color: Colors.red,
      );
    }
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
                    'Login',
                    style: AppStyles.settingsTabLabel.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: CustomButton(
                      text: 'Login',
                      onPressed: _handleLogin,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account ?",
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterView(),
                            ),
                          );
                        },
                        child: Text(
                          'Register',
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
