import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';

import '../../constants.dart';
import '../../data/api/api_services.dart';
import '../../data/models/lottie_models.dart';

class QRScanView extends StatefulWidget {
  const QRScanView({super.key});

  @override
  State<QRScanView> createState() => _QRScanViewState();
}

class _QRScanViewState extends State<QRScanView> {
  final ApiServices api = ApiServices();
  bool scanned = false;
  MobileScannerController scannerController =
      MobileScannerController(cameraResolution: Size(1024, 1024));
  bool torch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            SizedBox(
              height: 350,
              width: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Builder(
                  builder: (context) {
                    return Stack(
                      children: [
                        MobileScanner(
                          controller: scannerController,
                          onDetect: (result) async {
                            if (scanned) return;
                            scanned = true;
                            String? userId = result.barcodes.first.rawValue;
                            if (userId == null || userId.isEmpty) {
                              return;
                            }
                            await scannerController.stop();

                            String message =
                                await api.markMemberAsAttended(userId);
                            if (message == "User checked in successfully") {
                              if (!context.mounted) {
                                return;
                              }
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Lottie.asset(LottieModels.success,
                                              height: 100),
                                          Text(message),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          if (!scannerController.isStarting) {
                                            try {
                                              await scannerController.start();
                                            } catch (e) {}
                                          }
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              ).then((onValue) {
                                scanned = false;
                              });
                            } else {
                              if (!context.mounted) {
                                return;
                              }
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height: 300,
                                      child: Column(
                                        children: [
                                          Lottie.asset(LottieModels.error),
                                          Text(message),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          if (!scannerController.isStarting) {
                                            try {
                                              await scannerController.start();
                                            } catch (e) {}
                                          }
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              ).then((onValue) {
                                scanned = false;
                              });
                            }
                          },
                        ),
                        QRScannerOverlay(
                          borderColor: AppColors.primary,
                          borderStrokeWidth: 18,
                          borderRadius: 22,
                          scanAreaWidth: 200,
                          scanAreaHeight: 200,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 120),
            Container(
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        scannerController.toggleTorch();
                        setState(() {
                          torch = !torch;
                        });
                      },
                      icon: Icon(
                        torch ? Icons.flash_on : Icons.flash_off,
                        color: AppColors.secondary,
                      )),
                  SizedBox(width: 50),
                  IconButton(
                    onPressed: () {
                      scannerController.switchCamera();
                    },
                    icon: Icon(
                      Icons.cameraswitch_sharp,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
