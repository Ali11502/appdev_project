import '../../pages/login_page.dart';
import '../../pages/register_page.dart';
import '../../providers/login_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginRegisterProvider(),
      child: Consumer<LoginRegisterProvider>(
        builder: (context, loginRegisterProvider, child) {
          if (loginRegisterProvider.showLoginPage) {
            return LoginPage(onTap: () => loginRegisterProvider.togglePages());
          } else {
            return RegisterPage(
              onTap: () => loginRegisterProvider.togglePages(),
            );
          }
        },
      ),
    );
  }
}
