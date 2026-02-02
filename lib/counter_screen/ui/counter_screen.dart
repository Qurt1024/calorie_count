import 'dart:io';
import 'package:calorie_count/counter_screen/bloc/counter_bloc.dart';
import 'package:calorie_count/counter_screen/bloc/counter_event.dart';
import 'package:calorie_count/counter_screen/bloc/counter_state.dart';
import 'package:calorie_count/home_screen/ui/home_screen.dart';
import 'package:calorie_count/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


class MealSelectionScreen extends StatelessWidget {
  const MealSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealSelectionBloc(),
      child: const MealSelectionView(),
    );
  }
}

class MealSelectionView extends StatelessWidget {
  const MealSelectionView({super.key});

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Choose image source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF7BCF9E)),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  context.read<MealSelectionBloc>().add(PickImageFromCamera());
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF7BCF9E)),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(dialogContext);
                  context.read<MealSelectionBloc>().add(PickImageFromGallery());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addToList(BuildContext context) {
    final state = context.read<MealSelectionBloc>().state;
    if (state.selectedImage == null) return;

    // Return product data to home screen
    Navigator.pop(context, Product(
      name: state.productName,
      calories: state.calories,
      imagePath: state.selectedImage!.path,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MealSelectionBloc, MealSelectionState>(
      listener: (context, state) {
        if (state is MealSelectionError && state.errorMessage != null) {
          _showErrorDialog(context, state.errorMessage!);
        } else if (state is MealSelectionRecognized) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product recognized!'),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF6BB992),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF9F6),
        body: BlocBuilder<MealSelectionBloc, MealSelectionState>(
          builder: (context, state) {
            return Stack(
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
                              onTap: () => context
                                  .read<MealSelectionBloc>()
                                  .add(PickImageFromCamera()),
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
                              onTap: () => context
                                  .read<MealSelectionBloc>()
                                  .add(PickImageFromGallery()),
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

                        // Image preview and product info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => _showImageSourceDialog(context),
                              child: Container(
                                width: 220,
                                height: 240,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB5BEB8),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: state.selectedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(24),
                                        child: Image.file(
                                          state.selectedImage!,
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
                                    state.productName,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${state.calories} cal',
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

                        // Recognize button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: state.selectedImage != null && !state.isLoading
                                ? () => context
                                    .read<MealSelectionBloc>()
                                    .add(RecognizeProduct())
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

                        // Add to list button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: state.selectedImage != null && !state.isLoading
                                ? () => _addToList(context)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7BCF9E),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFFB8D9C9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add to list',
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
                            onPressed: state.isLoading
                                ? null
                                : () => context
                                    .read<MealSelectionBloc>()
                                    .add(ResetSelection()),
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
                if (state.isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7BCF9E)),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}