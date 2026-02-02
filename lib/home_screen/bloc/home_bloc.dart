import 'package:calorie_count/home_screen/bloc/home_event.dart';
import 'package:calorie_count/home_screen/bloc/home_state.dart';
import 'package:calorie_count/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<HomeState> emit) {
    // Initialize with some sample products
    final products = [
      Product(name: 'Apple', calories: 120),
      Product(name: 'Banana', calories: 90),
    ];
    final totalCalories = _calculateTotalCalories(products);
    emit(HomeLoaded(products: products, totalCalories: totalCalories));
  }

  void _onAddProduct(AddProduct event, Emitter<HomeState> emit) {
    final currentProducts = List<Product>.from(state.products);
    currentProducts.add(event.product);
    final totalCalories = _calculateTotalCalories(currentProducts);
    emit(HomeLoaded(products: currentProducts, totalCalories: totalCalories));
  }

  void _onRemoveProduct(RemoveProduct event, Emitter<HomeState> emit) {
    final currentProducts = List<Product>.from(state.products);
    currentProducts.removeWhere((product) => product.id == event.productId);
    final totalCalories = _calculateTotalCalories(currentProducts);
    emit(HomeLoaded(products: currentProducts, totalCalories: totalCalories));
  }

  int _calculateTotalCalories(List<Product> products) {
    return products.fold(0, (sum, product) => sum + product.calories);
  }
}