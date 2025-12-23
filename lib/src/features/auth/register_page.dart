import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';

import 'package:trying_flutter/src/core/constants/app_assets.dart';
import 'package:trying_flutter/src/shared/widgets/responsive_layout.dart';
import 'package:trying_flutter/src/core/theme/app_colors.dart';
import 'package:trying_flutter/src/shared/utils/app_validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _agreedWithTermsOfUse = ValueNotifier<bool>(false);

  final _showPassword = ValueNotifier<bool>(false);
  final _showConfirmPassword = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();

  void _register() {
    // TODO implement registration logic
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Processando register...')));
      context.go('/admin/dashboard');
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
            children: [_buildRegisterForm()],
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
              child: _buildRegisterForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
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
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: AppValidators.validateName,
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _cpfController,
                    decoration: const InputDecoration(
                      labelText: 'CPF',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O CPF é obrigatório';
                      }
                      if (!CPFValidator.isValid(value)) return 'CPF inválido';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email),
                      hintText: 'exemplo@email.com'
                    ),
                    validator: AppValidators.validateEmail
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: Icon(Icons.phone),
                      hintText: '(99) 99999-9999',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    validator: AppValidators.validatePhone,
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
                        validator: AppValidators.validatePassword
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  ValueListenableBuilder<bool>(
                    valueListenable: _showConfirmPassword,
                    builder: (context, showPass, child) {
                      return TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !showPass,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
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
                            onPressed: () =>
                                _showConfirmPassword.value = !showPass,
                          ),
                        ),
                        validator: (_) => AppValidators.validateConfirmPassword(
                          _passwordController.text,
                          _confirmPasswordController.text,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  FormField<bool>(
                    initialValue: _agreedWithTermsOfUse.value,
                    validator: (value) {
                      if (value != true) {
                        return 'Você precisa aceitar os termos para continuar';
                      }
                      return null;
                    },
                    builder: (FormFieldState<bool> state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: state.value,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (v) {
                                    state.didChange(v);
                                    if (v != null) {
                                      _agreedWithTermsOfUse.value = v;
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'Eu li e concordo com os ',
                                      ),
                                      TextSpan(
                                        text: 'Termos de Uso',
                                        style: TextStyle(
                                          color: AppColors.links,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            /* Navegação aqui */
                                          },
                                      ),
                                      const TextSpan(text: ' e com as '),
                                      TextSpan(
                                        text: 'Políticas de Privacidade',
                                        style: TextStyle(
                                          color: AppColors.links,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {},
                                      ),
                                      const TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 36, top: 5),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _register,
                      child: const Text('CADASTRAR'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => context.go('/'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Text(
                      'Já tenho uma conta',
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
