
import 'package:smartory_app/domain/entities/product.dart';
import 'package:smartory_app/infrastructure/models/product_model.dart';

class ProductMapper {

  static Product toEntity(ProductModel productModel) => Product(
    id: productModel.id,
    name: productModel.name,
    description: productModel.description,
    images: productModel.images.map((image) => ProductImage(id: image.id, url: image.url)).toList(),
    category: productModel.category.name,
    producer: productModel.producer.name
  );

}