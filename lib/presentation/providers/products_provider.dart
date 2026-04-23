import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/domain/entities/product.dart';
import 'package:smartory_app/domain/repositories/product_repository.dart';
import 'package:smartory_app/infrastructure/datasources/products_db_impl.dart';
import 'package:smartory_app/infrastructure/repositories/products_repository_impl.dart';

//1. State

class ProductsState {
  final List<Product>? products;

  ProductsState({this.products});

  ProductsState copyWith({List<Product>? products}) =>
      ProductsState(products: products ?? this.products);
}

//2. Notifier

final productsRepositoryProvider = Provider<ProductRepository>((ref) {
  final productsDatasource = ProductsDatasourceImpl();
  return ProductsRepositoryImpl(productDatasource: productsDatasource);
});

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
}
//3. Provider

final productsProvider = AsyncNotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new,
);
