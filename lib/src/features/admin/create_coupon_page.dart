import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/admin_drawer.dart';
import '../../shared/formatters/upper_case_text_formatter.dart';

enum DiscountType { percentage, fixedAmount }

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

  @override
  void dispose() {
    // Boa prática: limpar controladores quando sair da tela para liberar memória
    _nameController.dispose();
    _codeController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _saveCoupon() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final code = _codeController.text;
      final value = double.parse(_valueController.text.replaceAll(',', '.'));
      
      print('--- Cupom Salvo ---');
      print('Nome: $name');
      print('Código: $code');
      print('Tipo: $_selectedType');
      print('Valor: $value');

      // TODO: No próximo passo, geraremos o QRCode aqui
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cupom validado com sucesso!')),
      );
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Cupom')),
      drawer: const AdminDrawer(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Dados do Cupom',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        if (value == null || value.isEmpty) return 'Informe o nome';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(
                        labelText: 'Código do Cupom',
                        border: OutlineInputBorder(),
                        helperText: 'Apenas letras e números (sem espaços)',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), 
                        UpperCaseTextFormatter(), 
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Informe o código';
                        final validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
                        if (!validCharacters.hasMatch(value)) {
                          return 'Não use espaços ou caracteres especiais';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<DiscountType>(
                            initialValue: _selectedType,
                            decoration: const InputDecoration(
                              labelText: 'Tipo do desconto',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: DiscountType.percentage,
                                child: Text('Porcentagem (%)'),
                              ),
                              DropdownMenuItem(
                                value: DiscountType.fixedAmount,
                                child: Text('Fixo (R\$)'),
                              ),
                            ],
                            onChanged: (DiscountType? newValue) {
                              setState(() {
                                _selectedType = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _valueController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'Valor do Desconto',
                              border: OutlineInputBorder(),
                              prefixText: _selectedType == DiscountType.fixedAmount ? 'R\$ ' : '% ',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Informe o valor';
                              final number = double.tryParse(value.replaceAll(',', '.'));
                              if (number == null) return 'Valor inválido';
                              if (number <= 0) return 'Deve ser maior que 0';
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
                        onPressed: _saveCoupon,
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
      ),
    );
  }
}

