import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;

import 'package:lign_financial/core/themes/app_colors.dart';
import 'package:lign_financial/features/qris/viewmodel/qris_viewmodel.dart';

/// QRIS Scan Page — real camera scanning + gallery upload.
class QRISScreen extends ConsumerStatefulWidget {
  const QRISScreen({super.key});

  @override
  ConsumerState<QRISScreen> createState() => _QRISScreenState();
}

class _QRISScreenState extends ConsumerState<QRISScreen>
    with WidgetsBindingObserver {
  late final MobileScannerController _scannerController;
  final ImagePicker _imagePicker = ImagePicker();

  /// Prevents duplicate scan processing.
  bool _isProcessing = false;

  /// Whether camera permission has been resolved.
  bool _cameraPermissionChecked = false;
  bool _cameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Reset QRIS state every time the page is entered.
    Future.microtask(() {
      ref.read(qrisViewModelProvider.notifier).reset();
    });

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      autoStart: false, // We'll start manually after permission check.
    );

    _checkCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.dispose();
    super.dispose();
  }

  /// Re-check permission when user returns from Settings.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_cameraPermissionGranted) {
      _checkCameraPermission();
    }
  }

  // ---------------------------------------------------------------------------
  // Permission Handling
  // ---------------------------------------------------------------------------

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      _onCameraPermissionGranted();
      return;
    }

    if (status.isDenied) {
      // First-time or previously denied (not permanently).
      final result = await Permission.camera.request();
      if (result.isGranted) {
        _onCameraPermissionGranted();
        return;
      }
    }

    // Permanently denied or restricted — show manual guidance.
    if (mounted) {
      setState(() {
        _cameraPermissionChecked = true;
        _cameraPermissionGranted = false;
      });
    }
  }

  void _onCameraPermissionGranted() {
    if (!mounted) return;
    setState(() {
      _cameraPermissionChecked = true;
      _cameraPermissionGranted = true;
    });
    _scannerController.start();
  }

  Future<bool> _ensurePhotoPermission() async {
    final status = await Permission.photos.status;

    if (status.isGranted || status.isLimited) return true;

    if (status.isDenied) {
      final result = await Permission.photos.request();
      if (result.isGranted || result.isLimited) return true;
    }

    // Permanently denied — guide user to Settings.
    if (mounted) {
      _showPermissionDeniedDialog(
        title: 'Photo Library Access Required',
        message:
            'Please enable photo library access in Settings to upload QR code images.',
      );
    }
    return false;
  }

  void _showPermissionDeniedDialog({
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: LignColors.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: LignColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          message,
          style: GoogleFonts.inter(color: LignColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: LignColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: Text(
              'Open Settings',
              style: GoogleFonts.inter(
                color: LignColors.electricLime,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QR Processing
  // ---------------------------------------------------------------------------

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final rawValue = barcodes.first.rawValue;
    if (rawValue == null || rawValue.trim().isEmpty) return;

    setState(() => _isProcessing = true);
    _scannerController.stop();

    await _processQrContent(rawValue);
  }

  Future<void> _onGalleryPick() async {
    if (_isProcessing) return;

    // Check photo library permission explicitly.
    final hasPermission = await _ensurePhotoPermission();
    if (!hasPermission) return;

    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    setState(() => _isProcessing = true);

    // Stop the live camera to avoid resource contention.
    if (_cameraPermissionGranted) _scannerController.stop();

    // Use MLKit directly — more reliable than MobileScannerController.analyzeImage().
    final barcodeScanner = mlkit.BarcodeScanner(
      formats: [mlkit.BarcodeFormat.qrCode],
    );

    try {
      final inputImage = mlkit.InputImage.fromFilePath(pickedFile.path);
      final barcodes = await barcodeScanner.processImage(inputImage);

      if (!mounted) return;

      if (barcodes.isEmpty) {
        _showError('Could not decode QR code from the selected image.');
        _resetAfterError();
        return;
      }

      final rawValue = barcodes.first.rawValue;
      if (rawValue == null || rawValue.trim().isEmpty) {
        _showError('QR code content is empty.');
        _resetAfterError();
        return;
      }

      await _processQrContent(rawValue);
    } catch (e) {
      if (mounted) {
        _showError('Failed to analyze QR image. Please try again.');
        _resetAfterError();
      }
    } finally {
      barcodeScanner.close();
    }
  }

  void _resetAfterError() {
    setState(() => _isProcessing = false);
    if (_cameraPermissionGranted) _scannerController.start();
  }

  Future<void> _processQrContent(String content) async {
    final viewModel = ref.read(qrisViewModelProvider.notifier);
    final success = await viewModel.onQrScanned(content);

    if (!mounted) return;

    if (success) {
      context.push('/qris/confirm');
      setState(() => _isProcessing = false);
      if (_cameraPermissionGranted) _scannerController.start();
    } else {
      final errorMessage = ref.read(qrisViewModelProvider).errorMessage;
      _showError(errorMessage ?? 'Failed to process QR code.');
      setState(() => _isProcessing = false);
      if (_cameraPermissionGranted) _scannerController.start();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: LignColors.error,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qrisViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview or permission state
          if (_cameraPermissionGranted)
            MobileScanner(
              controller: _scannerController,
              onDetect: _onBarcodeDetected,
              errorBuilder: (context, error, child) =>
                  _buildCameraError(error),
            )
          else if (_cameraPermissionChecked)
            _buildPermissionDeniedView()
          else
            const Center(
              child: CircularProgressIndicator(
                color: LignColors.electricLime,
              ),
            ),

          // Dark overlay with transparent scan window
          if (_cameraPermissionGranted) _buildScanOverlay(),

          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Scan QRIS',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    // Torch toggle — only when camera is active
                    if (_cameraPermissionGranted)
                      IconButton(
                        onPressed: () => _scannerController.toggleTorch(),
                        icon: ValueListenableBuilder<MobileScannerState>(
                          valueListenable: _scannerController,
                          builder: (context, scannerState, _) {
                            return Icon(
                              scannerState.torchState == TorchState.on
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              color: Colors.white,
                              size: 28,
                            );
                          },
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_cameraPermissionGranted)
                      Text(
                        'Point your camera at a QRIS code',
                        style: GoogleFonts.inter(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Gallery upload button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: state.isLoading ? null : _onGalleryPick,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Upload from Gallery'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loading overlay
          if (state.isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      color: LignColors.electricLime,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Processing QR code...',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sub-widgets
  // ---------------------------------------------------------------------------

  /// Shown when camera permission is permanently denied.
  Widget _buildPermissionDeniedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white38,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Camera Access Required',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Camera permission was denied. Please enable it in '
              'your device settings to scan QR codes.',
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => openAppSettings(),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Open Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: LignColors.electricLime,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Or use the gallery upload below',
              style: GoogleFonts.inter(
                color: Colors.white38,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const scanAreaSize = 260.0;
        final left = (constraints.maxWidth - scanAreaSize) / 2;
        final top = (constraints.maxHeight - scanAreaSize) / 2 - 40;

        return Stack(
          children: [
            // Semi-transparent dark overlay
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.black54,
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Positioned(
                    left: left,
                    top: top,
                    child: Container(
                      width: scanAreaSize,
                      height: scanAreaSize,
                      decoration: BoxDecoration(
                        color: Colors.red, // Any color — will be cut out
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scan frame border
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: scanAreaSize,
                height: scanAreaSize,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LignColors.electricLime,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCameraError(MobileScannerException error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white38,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Error',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'An error occurred while accessing the camera. '
              'You can still upload a QR image from your gallery.',
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
