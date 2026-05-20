import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartory_app/presentation/providers/repositories/product_repository_provider.dart';
import 'package:smartory_app/presentation/providers/scanner/camera_provider.dart';

enum ScannerMode { receipt, barcode }

class TakePictureScreen extends ConsumerStatefulWidget {
  const TakePictureScreen({super.key});

  @override
  ConsumerState<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends ConsumerState<TakePictureScreen> {
  ScannerMode scannerMode = ScannerMode.receipt;
  XFile? capturedImage;
  bool isSending = false;
  Barcode? _barcode;

  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
      showModalBottomSheet(
        useSafeArea: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          final rootContext = this.context;

                          Navigator.of(context).pop(); // cierra el bottom sheet

                          showDialog(
                            context: rootContext,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          try {
                            final product = ref
                                .read(productsRepositoryProvider)
                                .getProductsByName(_barcode!.displayValue!);
                            print(product);
                            if (!mounted) return;

                            Navigator.of(rootContext).pop(); // cierra loading

                            ScaffoldMessenger.of(rootContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Inventario actualizado correctamente',
                                ),
                              ),
                            );

                            // ref
                            //     .read(audioInstructionsProvider.notifier)
                            //     .clearInstructions();
                          } catch (e) {
                            if (!mounted) return;

                            Navigator.of(rootContext).pop(); // cierra loading

                            ScaffoldMessenger.of(rootContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error al actualizar inventario: $e',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Confirmar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraAsync = ref.watch(cameraProvider);

    return cameraAsync.when(
      data: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // if (capturedImage == null)
                //   CameraPreview(controller)
                // else
                //   Image.file(File(capturedImage!.path), fit: BoxFit.cover),
                MobileScanner(onDetect: _handleBarcode),
                ScannerOverlay(mode: scannerMode),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 100,
                    color: const Color.fromRGBO(0, 0, 0, 0.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Center(child: _barcodePreview(_barcode)),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
                if (capturedImage == null)
                  Positioned(
                    bottom: 120,
                    left: 24,
                    right: 24,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                scannerMode = ScannerMode.receipt;
                              });
                            },
                            child: const Text('Boleta'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                scannerMode = ScannerMode.barcode;
                              });
                            },
                            child: const Text('Código'),
                          ),
                        ),
                      ],
                    ),
                  ),
                Positioned(
                  bottom: 32,
                  left: 24,
                  right: 24,
                  child: capturedImage == null
                      ? Center(
                          child: GestureDetector(
                            onTap: () async {
                              // final picture = await controller.takePicture();

                              // setState(() {
                              //   capturedImage = picture;
                              // });
                            },
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 32,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // setState(() {
                                  //   capturedImage = null;
                                  // });
                                },
                                icon: const Icon(Icons.close),
                                label: const Text('Descartar'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isSending
                                    ? null
                                    : () async {
                                        setState(() {
                                          isSending = true;
                                        });

                                        // enviar backend

                                        setState(() {
                                          isSending = false;
                                        });
                                      },
                                icon: isSending
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.send),
                                label: Text(
                                  isSending ? 'Enviando...' : 'Enviar',
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class ScannerOverlay extends StatelessWidget {
  final ScannerMode mode;

  const ScannerOverlay({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: ScannerOverlayPainter(mode: mode),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final ScannerMode mode;

  ScannerOverlayPainter({required this.mode});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.8);

    final clearPaint = Paint()..blendMode = BlendMode.clear;

    final overlayLayer = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.saveLayer(overlayLayer, Paint());

    canvas.drawRect(overlayLayer, backgroundPaint);

    final scanRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: mode == ScannerMode.receipt ? 420 : 160,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, const Radius.circular(20)),
      clearPaint,
    );

    canvas.restore();

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(scanRect, const Radius.circular(20)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.mode != mode;
  }
}
