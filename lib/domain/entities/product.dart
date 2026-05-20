class Product {
  final String id;
  final String name;
  final String description;
  final List<ProductImage> images;
  final String category;
  final String producer;
  // TODO: agregar quantity y amount

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.category,
    required this.producer,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images.map((image) => image.toJson()).toList(),
      'category': category,
      'producer': producer,
    };
  }
}

class ProductImage {
  final String id;
  final String url;

  ProductImage({required this.id, required this.url});

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url};
  }
}
