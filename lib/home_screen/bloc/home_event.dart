import 'package:calorie_count/home_screen/ui/home_screen.dart';
import 'package:calorie_count/product_model.dart';

abstract class HomeEvent {}

class LoadProducts extends HomeEvent {}

class AddProduct extends HomeEvent {
  final Product product;

  AddProduct(this.product);
}

class RemoveProduct extends HomeEvent {
  final String productId;

  RemoveProduct(this.productId);
}