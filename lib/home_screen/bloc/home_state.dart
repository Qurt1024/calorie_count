import 'package:calorie_count/home_screen/ui/home_screen.dart';
import 'package:calorie_count/product_model.dart';

abstract class HomeState {
  final List<Product> products;
  final int totalCalories;

  HomeState({required this.products, required this.totalCalories});
}

class HomeInitial extends HomeState {
  HomeInitial() : super(products: [], totalCalories: 0);
}

class HomeLoading extends HomeState {
  HomeLoading({required super.products, required super.totalCalories});
}

class HomeLoaded extends HomeState {
  HomeLoaded({required super.products, required super.totalCalories});
}

class HomeError extends HomeState {
  final String message;

  HomeError({
    required super.products,
    required super.totalCalories,
    required this.message,
  });
}