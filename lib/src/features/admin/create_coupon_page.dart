import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';

import 'widgets/admin_drawer.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';
import 'package:trying_flutter/src/shared/repositories/coupon_repository.dart';
import 'package:trying_flutter/src/features/admin/widgets/coupon_form.dart';

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
  final _usageController = TextEditingController();

  DiscountType _selectedType = DiscountType.percentage;

  String? _qrData;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _valueController.dispose();
    _usageController.dispose();
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

        final existingCoupon = await _repository.showCoupon(coupon);

        if (existingCoupon != null) {
          throw 'Já existe um cupom com este código.';
        }
        
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
                    child: CouponForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      codeController: _codeController,
                      valueController: _valueController,
                      selectedType: _selectedType,
                      usageController: _usageController,
                      isLoading: _isLoading,
                      submitLabel: 'SALVAR E GERAR QR',

                      onTypeChanged: (newValue) {
                        if (newValue != null) {
                          setState(() => _selectedType = newValue);
                        }
                      },

                      onSubmit: _generateQRCode,

                      onCancel: () => context.go('/admin/coupons'),
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
