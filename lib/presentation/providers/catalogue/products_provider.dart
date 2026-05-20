import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/domain/entities/product.dart';

import 'package:smartory_app/presentation/providers/repositories/product_repository_provider.dart';

//1. State

class ProductsState {
  final String? searchQuery;
  final List<Product>? products;

  ProductsState({this.products, this.searchQuery});

  ProductsState copyWith({List<Product>? products, String? searchQuery}) =>
      ProductsState(
        products: products ?? this.products,
        searchQuery: searchQuery ?? this.searchQuery,
      );
}

//2. Notifier
class ProductsNotifier extends AsyncNotifier<ProductsState> {
  @override
  Future<ProductsState> build() async {
    final repository = ref.read(productsRepositoryProvider);
    final products = await repository.getProducts();
    return ProductsState(products: products);
  }

  Future<void> loadProducts() async {
    final repository = ref.read(productsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final products = await repository.getProducts();
      return ProductsState(products: products);
    });
  }

  Future<void> searchProductsByName(String query) async {
    final repository = ref.read(productsRepositoryProvider);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final products = await repository.getProductsByName(query);
      return ProductsState(products: products, searchQuery: query);
    });
  }
}
//3. Provider

final productsProvider = AsyncNotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new,
);
