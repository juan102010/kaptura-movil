import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/localization/localization_extension.dart';

class InventoryQrScannerPage extends StatefulWidget {
  const InventoryQrScannerPage({super.key});

  @override
  State<InventoryQrScannerPage> createState() => _InventoryQrScannerPageState();
}

class _InventoryQrScannerPageState extends State<InventoryQrScannerPage> {
  bool _didDetect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(context.l10n.scanQr),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (_didDetect) return;

              final code = capture.barcodes
                  .map((item) => item.rawValue?.trim() ?? '')
                  .firstWhere((item) => item.isNotEmpty, orElse: () => '');

              if (code.isEmpty) return;

              _didDetect = true;
              context.pop(code);
            },
          ),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                context.l10n.scanQrHelp,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
