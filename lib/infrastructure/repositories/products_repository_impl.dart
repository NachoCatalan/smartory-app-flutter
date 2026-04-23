
import 'package:smartory_app/domain/datasources/product_datasource.dart';
import 'package:smartory_app/domain/entities/product.dart';
import 'package:smartory_app/domain/repositories/product_repository.dart';

class ProductsRepositoryImpl extends ProductRepository {

  final ProductDatasource productDatasource;

  ProductsRepositoryImpl({
    required this.productDatasource
  });

  @override
  Future<Product?> getProductById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Product>?> getProducts() {
    return productDatasource.getProducts();
  }
  
  @override
  Future<Product?> getProductByName(String name) {
    // TODO: implement getProductByName
    throw UnimplementedError();
  }
}