import 'dart:io';
import 'dart:math';

import 'package:calorie_count/counter_screen/bloc/counter_event.dart';
import 'package:calorie_count/counter_screen/bloc/counter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class MealSelectionBloc extends Bloc<MealSelectionEvent, MealSelectionState> {
  final ImagePicker _picker = ImagePicker();

  MealSelectionBloc() : super(MealSelectionInitial()) {
    on<PickImageFromCamera>(_onPickImageFromCamera);
    on<PickImageFromGallery>(_onPickImageFromGallery);
    on<ImageSelected>(_onImageSelected);
    on<RecognizeProduct>(_onRecognizeProduct);
    on<ResetSelection>(_onResetSelection);
  }

  Future<void> _onPickImageFromCamera(
    PickImageFromCamera event,
    Emitter<MealSelectionState> emit,
  ) async {
    emit(MealSelectionImagePicking(
      selectedImage: state.selectedImage,
      productName: state.productName,
      calories: state.calories,
    ));

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        emit(MealSelectionImageSelected(
          selectedImage: File(image.path),
          productName: state.productName,
          calories: state.calories,
        ));
      } else {
        emit(MealSelectionInitial());
      }
    } catch (e) {
      emit(MealSelectionError(
        selectedImage: state.selectedImage,
        productName: state.productName,
        calories: state.calories,
        errorMessage: 'Error picking image from camera: $e',
      ));
    }
  }

  Future<void> _onPickImageFromGallery(
    PickImageFromGallery event,
    Emitter<MealSelectionState> emit,
  ) async {
    emit(MealSelectionImagePicking(
      selectedImage: state.selectedImage,
      productName: state.productName,
      calories: state.calories,
    ));

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        emit(MealSelectionImageSelected(
          selectedImage: File(image.path),
          productName: state.productName,
          calories: state.calories,
        ));
      } else {
        emit(MealSelectionInitial());
      }
    } catch (e) {
      emit(MealSelectionError(
        selectedImage: state.selectedImage,
        productName: state.productName,
        calories: state.calories,
        errorMessage: 'Error picking image from gallery: $e',
      ));
    }
  }

  void _onImageSelected(
    ImageSelected event,
    Emitter<MealSelectionState> emit,
  ) {
    emit(MealSelectionImageSelected(
      selectedImage: event.image,
      productName: state.productName,
      calories: state.calories,
    ));
  }

  Future<void> _onRecognizeProduct(
    RecognizeProduct event,
    Emitter<MealSelectionState> emit,
  ) async {
    if (state.selectedImage == null) return;

    emit(MealSelectionRecognizing(
      selectedImage: state.selectedImage,
      productName: state.productName,
      calories: state.calories,
    ));

    // Simulate AI recognition
    await Future.delayed(const Duration(seconds: 2));

    final foods = ['Apple', 'Banana', 'Chocolate', 'Milk', 'Bread', 'Salad', 'Orange', 'Yogurt'];
    final randomFood = foods[Random().nextInt(foods.length)];
    final randomCalories = Random().nextInt(1000);

    emit(MealSelectionRecognized(
      selectedImage: state.selectedImage,
      productName: randomFood,
      calories: randomCalories,
    ));
  }

  void _onResetSelection(
    ResetSelection event,
    Emitter<MealSelectionState> emit,
  ) {
    emit(MealSelectionInitial());
  }
}
