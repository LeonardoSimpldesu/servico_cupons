import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/repositories/coupon_repository.dart';
import 'package:trying_flutter/src/features/admin/widgets/coupon_form.dart';
import 'widgets/admin_drawer.dart';

class EditCouponPage extends StatefulWidget {
  final CouponModel coupon;

  const EditCouponPage({super.key, required this.coupon});

  @override
  State<EditCouponPage> createState() => _EditCouponPageState();
}

class _EditCouponPageState extends State<EditCouponPage> {
  final _formKey = GlobalKey<FormState>();
  final CouponRepository _repository = CouponRepository();

  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _valueController;
  late DiscountType _selectedType;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.coupon.name);
    _codeController = TextEditingController(text: widget.coupon.code);
    _valueController = TextEditingController(
      text: widget.coupon.value.toString().replaceAll('.', ','),
    );
    _selectedType = widget.coupon.type;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _updateCoupon() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final updatedCoupon = CouponModel(
          name: _nameController.text,
          code: _codeController.text,
          type: _selectedType,
          value: double.parse(_valueController.text.replaceAll(',', '.')),
        );

        await _repository.updateCoupon(updatedCoupon);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cupom atualizado com sucesso!')),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar: ${widget.coupon.code}')),
      drawer: const AdminDrawer(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(32),

                child: CouponForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  codeController: _codeController,
                  valueController: _valueController,
                  selectedType: _selectedType,
                  isLoading: _isLoading,

                  isEditing: true,
                  submitLabel: 'SALVAR ALTERAÇÕES',

                  onTypeChanged: (newValue) {
                    if (newValue != null) {
                      setState(() => _selectedType = newValue);
                    }
                  },

                  onSubmit: _updateCoupon,
                  onCancel: () => context.pop(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
