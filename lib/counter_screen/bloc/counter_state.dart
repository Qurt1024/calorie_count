import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class MealSelectionState {
  final File? selectedImage;
  final String productName;
  final int calories;
  final bool isLoading;
  final String? errorMessage;

  MealSelectionState({
    this.selectedImage,
    this.productName = 'Apple',
    this.calories = 120,
    this.isLoading = false,
    this.errorMessage,
  });
}

class MealSelectionInitial extends MealSelectionState {
  MealSelectionInitial() : super();
}

class MealSelectionImagePicking extends MealSelectionState {
  MealSelectionImagePicking({
    super.selectedImage,
    super.productName,
    super.calories,
    super.errorMessage,
  }) : super(isLoading: true);
}

class MealSelectionImageSelected extends MealSelectionState {
  MealSelectionImageSelected({
    required super.selectedImage,
    super.productName,
    super.calories,
    super.errorMessage,
  }) : super(isLoading: false);
}

class MealSelectionRecognizing extends MealSelectionState {
  MealSelectionRecognizing({
    required super.selectedImage,
    super.productName,
    super.calories,
    super.errorMessage,
  }) : super(isLoading: true);
}

class MealSelectionRecognized extends MealSelectionState {
  MealSelectionRecognized({
    required super.selectedImage,
    required super.productName,
    required super.calories,
    super.errorMessage,
  }) : super(isLoading: false);
}

class MealSelectionError extends MealSelectionState {
  MealSelectionError({
    super.selectedImage,
    super.productName,
    super.calories,
    required super.errorMessage,
  }) : super(isLoading: false);
}