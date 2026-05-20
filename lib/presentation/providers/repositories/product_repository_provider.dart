import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/domain/repositories/product_repository.dart';
import 'package:smartory_app/infrastructure/datasources/datasources.dart';
import 'package:smartory_app/infrastructure/repositories/repositories.dart';

final productsRepositoryProvider = Provider<ProductRepository>((ref) {
  final productsDatasource = ProductsDatasourceImpl();
  return ProductsRepositoryImpl(productDatasource: productsDatasource);
});
