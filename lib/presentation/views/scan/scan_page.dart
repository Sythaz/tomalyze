import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tomalyze/core/constants/app_icons.dart';
import 'package:tomalyze/core/constants/app_text_styles.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/camera_frame.dart';
import '../../widgets/confirm_dialog.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _cameraController;
  bool _isInitialized = false;
  File? _capturedPhoto;
  bool _isLoadingCamera = true;
  bool _isPermissAllowed = false;

  Future<bool> _checkCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    return false;
  }

  Future<void> _init() async {
    final allowed = await _checkCameraPermission();

    setState(() => _isPermissAllowed = allowed);

    if (!allowed) {
      if (!mounted) return;
      setState(() {
        _isInitialized = false;
        _isLoadingCamera = false;
      });
      return;
    }

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setState(() => _isLoadingCamera = true);

    try {
      final cameras = await availableCameras();

      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.last,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (!mounted) return;

      setState(() {
        _isLoadingCamera = false;
        _isInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitialized = false;
        _isLoadingCamera = false;
      });
    }
  }

  Future<void> _capturePhoto(BuildContext context) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final file = await _cameraController!.takePicture();
    File capturedFile = File(file.path);

    try {
      await _cameraController?.pausePreview();
    } catch (_) {}

    setState(() => _capturedPhoto = capturedFile);
  }

  Future<void> _retakePhoto() async {
    final isRetake = await showConfirmationDialog(
      context: context,
      title: 'Konfirmasi',
      content: 'Apakah Anda yakin ingin mengulang foto tomat ini?',
      cancelText: 'Batal',
      confirmText: 'Ya, Ambil Ulang',
    );

    if (isRetake) {
      try {
        await _cameraController?.resumePreview();
      } catch (_) {}

      setState(() => _capturedPhoto = null);
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _init();
  }

  @override
  void dispose() {
    _cameraController?.dispose();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(context),
      body: Builder(
        builder: (context) {
          if (_isLoadingCamera || !_isInitialized) {
            const Center(child: CircularProgressIndicator());
          }
          if (!_isPermissAllowed) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Izin kamera belum diberikan, \nsilakan aktifkan di setting',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regular,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warningOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await openAppSettings();
                      _init();
                    },
                    child: Text(
                      'Buka Pengaturan',
                      style: AppTextStyles.semiBold,
                    ),
                  ),
                ],
              ),
            );
          }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildCameraPreview(context),
                  SizedBox(height: 20),
                  Text(
                    'Align the tomato inside the frame',
                    style: AppTextStyles.regular.copyWith(fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    _capturedPhoto != null
                        ? 'Retake photo'
                        : 'Click to take photo',
                    style: AppTextStyles.regular.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: _isLoadingCamera
                        ? null
                        : () {
                            if (_capturedPhoto != null) {
                              _retakePhoto();
                            } else {
                              _capturePhoto(context);
                            }
                          },
                    child: Container(
                      width: 70,
                      height: 70,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.primaryRed,
                      ),
                      child: _capturedPhoto != null
                          ? const Icon(
                              Icons.replay,
                              fontWeight: FontWeight.bold,
                              size: 42,
                              color: AppColors.white,
                            )
                          : SvgPicture.asset(AppIcons.camera, height: 42),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AspectRatio _buildCameraPreview(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 1,
                child: () {
                  if (!_isInitialized && !_isLoadingCamera) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_capturedPhoto != null) {
                    return Image.file(_capturedPhoto!);
                  } else if (_cameraController?.value.isInitialized == true) {
                    return CameraPreview(_cameraController!);
                  } else {
                    return Center(child: Text('Kamera belum siap'));
                  }
                }(),
              ),
            ),

            (_capturedPhoto != null || !_isInitialized)
                ? const SizedBox.shrink()
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 50,
                      ),
                      child: CameraFrame(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        cornerWidth: 3,
                        cornerLength: 80,
                        borderRadius: 0,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, fontWeight: FontWeight.bold),
        onPressed: () async {
          if (_capturedPhoto == null) return Navigator.pop(context);

          final isExit = await showConfirmationDialog(
            context: context,
            title: 'Konfirmasi',
            content:
                'Apakah Anda yakin ingin keluar?\nFoto yang telah diambil mungkin akan hilang.',
            cancelText: 'Batal',
            confirmText: 'Ya, Keluar',
          );
          if (isExit) {
            _capturedPhoto = null;
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        'Tomato Scan',
        style: AppTextStyles.bold.copyWith(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_capturedPhoto == null) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Uhm...',
                  message: 'Please take a photo first',

                  contentType: ContentType.failure,
                ),
              );
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);

              return;
            }
          },
          child: Text(
            'Next',
            style: AppTextStyles.bold.copyWith(
              color: AppColors.primaryRed,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
