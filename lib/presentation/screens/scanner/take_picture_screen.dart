import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartory_app/presentation/providers/catalogue/products_provider.dart';
import 'package:smartory_app/presentation/providers/repositories/product_repository_provider.dart';
import 'package:smartory_app/presentation/providers/scanner/camera_provider.dart';
import 'package:smartory_app/presentation/widgets/scanner/scanner_overlay.dart';

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
  bool scanned = false;
  InputImage? inputImage;
  String? scannedText;

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final MobileScannerController scannerController = MobileScannerController();

  _TakePictureScreenState();

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture captures) async {
    if (scanned || !mounted) return;

    final barcode = captures.barcodes.first;
    final value = barcode.rawValue;
    if (value == null) return;

    setState(() {
      _barcode = barcode;
      scanned = true;
    });

    scannerController.pause();
    await ref
        .read(productsProvider.notifier)
        .searchProductsByName(_barcode!.displayValue!);

    final product = ref.read(productsProvider).value!.products;
    if (mounted) {
      await showModalBottomSheet(
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
                child: SizedBox(
                  width: double.infinity,
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
                      Text(product!.first.name),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
      if (!mounted) return;
      setState(() {
        scanned = false;
      });
    }
  }

  Future<String?> extractTextFromCapture(CameraController controller) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final picture = await controller.takePicture();
    final preprocessedImage = await preprocessImage(picture.path);
    final InputImage inputImage = InputImage.fromFilePath(preprocessedImage);

    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    return recognizedText.text;
  }

  Future<String> preprocessImage(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return imagePath;
    image = img.grayscale(image);
    image = img.adjustColor(image, contrast: 1.5);
    if (image.width < 1000) {
      image = img.copyResize(image, width: 1500);
    }
    final tempDir = await getTemporaryDirectory();
    final processedPath = '${tempDir.path}/processed.jpg';
    await File(processedPath).writeAsBytes(img.encodeJpg(image, quality: 95));
    return processedPath;
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
                if (scannedText == null)
                  CameraPreview(controller)
                else
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(scannedText ?? ''),
                  ),
                // MobileScanner(
                //   onDetect: _handleBarcode,
                //   controller: scannerController,
                // ),
                if (scannedText == null) ScannerOverlay(mode: scannerMode),

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
                              final textResult = await extractTextFromCapture(
                                controller,
                              );
                              setState(() {
                                scannedText = textResult;
                              });
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
                                onPressed: () async {
                                  setState(() {
                                    capturedImage = null;
                                  });
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
