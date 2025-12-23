import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'widgets/admin_drawer.dart';
import 'package:trying_flutter/src/shared/formatters/upper_case_text_formatter.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';

class CreateCouponPage extends StatefulWidget {
  const CreateCouponPage({super.key});

  @override
  State<CreateCouponPage> createState() => _CreateCouponPageState();
}

class _CreateCouponPageState extends State<CreateCouponPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _valueController = TextEditingController();

  DiscountType _selectedType = DiscountType.percentage;

  String? _qrData;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _generateQRCode() {
  FocusScope.of(context).unfocus();
      if (_formKey.currentState!.validate()) {
        final coupon = CouponModel(
          name: _nameController.text,
          code: _codeController.text,
          type: _selectedType,
          value: double.parse(_valueController.text.replaceAll(',', '.')),
        );

        setState(() {
          _qrData = coupon.toJson(); 
        });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR Code gerado com sucesso!')),
      );
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
                              if (value == null || value.isEmpty)
                                return 'Informe o nome';
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
                                ? 'Informe o código'
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Informe o valor';
                                    }
                                    final number = double.tryParse(
                                      value.replaceAll(',', '.'),
                                    );
                                    if (number == null) return 'Valor inválido';
                                    if (number <= 0) {
                                      return 'Deve ser maior que 0';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _generateQRCode,
                              icon: const Icon(Icons.qr_code),
                              label: const Text('GERAR QR CODE'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
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
