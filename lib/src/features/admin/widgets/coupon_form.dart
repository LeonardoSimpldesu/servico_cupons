import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trying_flutter/src/shared/formatters/upper_case_text_formatter.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/utils/app_validators.dart';

class CouponForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController valueController;
  final TextEditingController usageController;

  final DiscountType selectedType;
  final ValueChanged<DiscountType?> onTypeChanged;

  final bool isEditing;
  final bool isLoading;
  final String submitLabel;
  final VoidCallback onSubmit;
  final VoidCallback? onCancel;

  const CouponForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.codeController,
    required this.valueController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onSubmit,
    required this.usageController,
    this.isEditing = false,
    this.isLoading = false,
    this.submitLabel = 'SALVAR',
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Dados do Cupom',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nome da Campanha',
              border: OutlineInputBorder(),
              helperText: 'Ex: Black Friday 2024',
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Nome obrigatório' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: codeController,
            readOnly: isEditing,
            decoration: InputDecoration(
              labelText: isEditing
                  ? 'Código (Não editável)'
                  : 'Código do Cupom',
              border: const OutlineInputBorder(),
              filled: isEditing,
              fillColor: isEditing ? Colors.grey.shade200 : null,
              helperText: isEditing ? null : 'Apenas letras e números',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              UpperCaseTextFormatter(),
            ],
            validator: (value) =>
                value?.isEmpty ?? true ? 'Código obrigatório' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: usageController,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            decoration: const InputDecoration(
              labelText: 'Quantidade de usos',
              border: OutlineInputBorder(),
              helperText: 'Ex: 50'
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            validator: (value) {
              if(value?.isEmpty ?? true) {
                return 'Quantidade obrigatória';
              }
              final intValue = int.tryParse(value!);
              if(intValue == null || intValue <= 0) {
                return 'Informe uma quantidade válida';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DropdownButtonFormField<DiscountType>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
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
                  onChanged: onTypeChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: valueController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  validator: (v) =>
                      AppValidators.validateCouponValue(v, selectedType),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.blue.shade200,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(submitLabel),
            ),
          ),

          if (onCancel != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: isLoading ? null : onCancel,
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              label: const Text('Voltar'),
            ),
          ],
        ],
      ),
    );
  }
}
