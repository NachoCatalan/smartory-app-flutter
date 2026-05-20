import 'package:smartory_app/domain/entities/product.dart';

abstract class ProductDatasource {
  // TODO: implementar paginación
  Future<List<Product>?> getProducts();

  Future<Product?> getProductById(String id);

  Future<List<Product>?> getProductsByName(String name);
}
