import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/core/constants/app_assets.dart';
import 'package:trying_flutter/src/shared/utils/app_validators.dart';
import 'package:trying_flutter/src/shared/widgets/responsive_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _showPassword = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();

  void _login() {
    // TODO implement registration logic
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Processando login...')));
      context.go('/admin/coupons');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ResponsiveLayout(
        mobile: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.backgroundLogin),
              fit: BoxFit.cover,
              opacity: 0.6,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_buildLoginForm()],
          ),
        ),

        desktop: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.backgroundLogin),
              fit: BoxFit.cover,
              opacity: 0.6,
            ),
            color: Color(0xFF121212),
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildLoginForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(AppAssets.logo, height: 100, fit: BoxFit.contain),

        const SizedBox(height: 24),

        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bem-vindo',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                      hintText: 'exemplo@email.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidators.validateEmail,
                  ),

                  const SizedBox(height: 16),

                  ValueListenableBuilder<bool>(
                    valueListenable: _showPassword,
                    builder: (context, showPass, child) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: !showPass,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIconColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => _showPassword.value = !showPass,
                          ),
                        ),
                        validator: AppValidators.validatePassword,
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text('ENTRAR'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => context.go('/register'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
