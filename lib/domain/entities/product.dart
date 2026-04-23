
class Product {

  final String id;
  final String name;
  final String description;
  final List<ProductImage> images;
  final String category;
  final String producer;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.category,
    required this.producer
  });

}

class ProductImage {

  final String id;
  final String url;

  ProductImage({required this.id, required this.url});

}