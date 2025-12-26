import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/core/theme/app_colors.dart';
import 'package:trying_flutter/src/shared/utils/app_validators.dart';
import 'widgets/admin_drawer.dart';
import 'package:trying_flutter/src/shared/formatters/upper_case_text_formatter.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/repositories/coupon_repository.dart';

class CreateCouponPage extends StatefulWidget {
  const CreateCouponPage({super.key});

  @override
  State<CreateCouponPage> createState() => _CreateCouponPageState();
}

class _CreateCouponPageState extends State<CreateCouponPage> {
  final _formKey = GlobalKey<FormState>();

  final CouponRepository _repository = CouponRepository();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();

  DiscountType _selectedType = DiscountType.percentage;

  String? _qrData;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _generateQRCode() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _qrData = null;
      });

      try {
        final coupon = CouponModel(
          name: _nameController.text,
          code: _codeController.text,
          type: _selectedType,
          value: double.parse(_valueController.text.replaceAll(',', '.')),
        );

        await _repository.createCoupon(coupon);

        setState(() {
          _qrData = coupon.toJson();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cupom salvo e QR Code gerado!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Cupom')),
      drawer: const AdminDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Dados do Cupom',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nome da Campanha',
                              border: OutlineInputBorder(),
                              helperText: 'Ex: Black Friday 2024',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nome obrigatório';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _codeController,
                            decoration: const InputDecoration(
                              labelText: 'Código do Cupom',
                              border: OutlineInputBorder(),
                              helperText:
                                  'Apenas letras e números (sem espaços)',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'),
                              ),
                              UpperCaseTextFormatter(),
                            ],
                            validator: (value) => value?.isEmpty ?? true
                                ? 'Código obrigatório'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<DiscountType>(
                                  initialValue: _selectedType,
                                  decoration: const InputDecoration(
                                    labelText: 'Tipo do desconto',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: DiscountType.percentage,
                                      child: Text('Percentagem (%)'),
                                    ),
                                    DropdownMenuItem(
                                      value: DiscountType.fixed,
                                      child: Text('Fixo (R\$)'),
                                    ),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _selectedType = v!),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _valueController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: const InputDecoration(
                                    labelText: 'Valor do Desconto',
                                    border: OutlineInputBorder(),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.,]'),
                                    ),
                                  ],
                                  validator: (value) =>
                                      AppValidators.validateCouponValue(
                                        value,
                                        _selectedType,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _generateQRCode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.blue.shade200,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.qr_code),
                                        SizedBox(width: 8),
                                        Text('SALVAR E GERAR QR'),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextButton.icon(
                            onPressed: () => context.go('/admin/coupons'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.mutedForeground,
                            ),
                            label: const Text('Voltar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (_qrData != null) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(10, 0, 0, 0).withValues(),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Cupom Gerado:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),

                      QrImageView(
                        data: _qrData!,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),

                      const SizedBox(height: 8),
                      Text(
                        _codeController.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
