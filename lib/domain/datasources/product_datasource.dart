
import 'package:smartory_app/domain/entities/product_entity.dart';

abstract class ProductDatasource {

  Future<List<Product>> getProducts();

  Future<Product?> getProductById(String id); 

}
