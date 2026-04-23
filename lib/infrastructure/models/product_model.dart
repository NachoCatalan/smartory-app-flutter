
class ProductModel {

  final String id;
  final String name;
  final String description;
  final List<ImagesModel> images;
  final Category category;
  final ProducerModel producer;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.category,
    required this.producer
  });

  factory ProductModel.fromJson(Map<String,dynamic> json) => ProductModel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    producer: ProducerModel.fromJson(json['producer']) ,
    category: Category.fromJson(json['category']),
    images: List.of(json['images']).map( (image) => ImagesModel.fromJson( image )).toList()
  );
}

class ImagesModel {

  final String id;
  final String url;

  ImagesModel({required this.id, required this.url});

  factory ImagesModel.fromJson( Map<String,dynamic> json ) => ImagesModel(
    id: json['id'],
    url: json['url']
  );
}

class ProducerModel {

  final int id;
  final String name;

  ProducerModel({required this.id, required this.name});

  factory ProducerModel.fromJson( Map<String,dynamic> json ) => ProducerModel(
    id: json['id'],
    name: json['name']
  );
}

class Category {

  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String,dynamic> json) => Category(
    id: json['id'],
    name: json['name']
  ); 
}