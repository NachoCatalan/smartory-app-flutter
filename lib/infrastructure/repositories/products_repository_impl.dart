

import 'package:smartory_app/domain/datasources/product_datasource.dart';
import 'package:smartory_app/domain/entities/product_entity.dart';
import 'package:smartory_app/domain/repositories/product_repository.dart';

class ProductsRepositoryImpl extends ProductRepository {

  final ProductDatasource productDatasource;

  ProductsRepositoryImpl({
    required this.productDatasource
  });

  @override
  Future<Product?> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProducts() {
    // TODO: implement getProducts
    throw UnimplementedError();
  }
}