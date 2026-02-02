import 'dart:io';

abstract class MealSelectionEvent {}

class PickImageFromCamera extends MealSelectionEvent {}

class PickImageFromGallery extends MealSelectionEvent {}

class ImageSelected extends MealSelectionEvent {
  final File image;

  ImageSelected(this.image);
}

class RecognizeProduct extends MealSelectionEvent {}

class ResetSelection extends MealSelectionEvent {}
