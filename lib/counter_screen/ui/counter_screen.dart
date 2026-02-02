import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MealSelectionApp());
}

class MealSelectionApp extends MaterialApp {
  const MealSelectionApp({super.key})
      : super(
          home: const MealSelectionScreen(),
          debugShowCheckedModeBanner: false,
        );
}

class MealSelectionState {
  final File? selectedImage;
  final String productName;
  final int calories;
  final bool isLoading;
  final String? errorMessage;

  const MealSelectionState({
    this.selectedImage,
    this.productName = 'Apple',
    this.calories = 120,
    this.isLoading = false,
    this.errorMessage,
  });

  MealSelectionState copyWith({
    File? selectedImage,
    String? productName,
    int? calories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MealSelectionState(
      selectedImage: selectedImage ?? this.selectedImage,
      productName: productName ?? this.productName,
      calories: calories ?? this.calories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  MealSelectionState reset() {
    return const MealSelectionState();
  }
}

class MealSelectionScreen extends StatefulWidget {
  const MealSelectionScreen({super.key});

  @override
  State<MealSelectionScreen> createState() => _MealSelectionScreenState();
}

class _MealSelectionScreenState extends State<MealSelectionScreen> {
  MealSelectionState _state = const MealSelectionState();
  final ImagePicker _picker = ImagePicker();

  void _updateState(MealSelectionState newState) {
    setState(() {
      _state = newState;
    });
  }

  Future<void> _pickImageFromCamera() async {
    try {
      _updateState(_state.copyWith(isLoading: true));

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        _updateState(_state.copyWith(
          selectedImage: File(image.path),
          isLoading: false,
        ));
      } else {
        _updateState(_state.copyWith(isLoading: false));
      }
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        errorMessage: 'Error picking image from camera: $e',
      ));
      _showErrorDialog(_state.errorMessage!);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      _updateState(_state.copyWith(isLoading: true));

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        _updateState(_state.copyWith(
          selectedImage: File(image.path),
          isLoading: false,
        ));
      } else {
        _updateState(_state.copyWith(isLoading: false));
      }
    } catch (e) {
      _updateState(_state.copyWith(
        isLoading: false,
        errorMessage: 'Error picking image from gallery: $e',
      ));
      _showErrorDialog(_state.errorMessage!);
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose image source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.camera_alt, color: Color(0xFF7BCF9E)),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.photo_library, color: Color(0xFF7BCF9E)),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateState(_state.copyWith(errorMessage: null));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _recognizeProduct() async {
    if (_state.selectedImage == null) return;

    _updateState(_state.copyWith(isLoading: true));


    await Future.delayed(const Duration(seconds: 2));

    _updateState(_state.copyWith(
      productName: 'Banana',
      calories: 105,
      isLoading: false,
    ));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product recognized!'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF6BB992),
        ),
      );
    }
  }

  void _cancel() {
    _updateState(_state.reset());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Text(
                    'Choose your meal',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Camera/Gallery tabs
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImageFromCamera,
                        child: const Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7BCF9E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: _pickImageFromGallery,
                        child: const Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7A7A7A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _showImageSourceDialog,
                        child: Container(
                          width: 220,
                          height: 240,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB5BEB8),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: _state.selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.file(
                                    _state.selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 48,
                                    color: Color(0xFF8A938D),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 24),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _state.productName,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_state.calories} cal',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7BCF9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _state.selectedImage != null && !_state.isLoading
                          ? _recognizeProduct
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA8E6C5),
                        foregroundColor: const Color(0xFF2C3E50),
                        disabledBackgroundColor: const Color(0xFFD4E8DD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Recognize the product',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _state.isLoading ? null : _cancel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6BB992),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFF9ABFAA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_state.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7BCF9E)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}