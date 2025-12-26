import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:trying_flutter/src/shared/models/coupon_model.dart';

void showQrCodeModal(BuildContext context, CouponModel coupon) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        constraints: BoxConstraints(maxWidth: 300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Text(
                coupon.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                coupon.code,
                style: const TextStyle(
                  fontSize: 16, 
                  color: Colors.grey, 
                  letterSpacing: 1.5
                ),
              ),
              const SizedBox(height: 24),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: coupon.code,
                  version: QrVersions.auto,
                  size: 220,
                ),
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('FECHAR'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}