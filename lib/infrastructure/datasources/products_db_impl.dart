import 'package:dio/dio.dart';

import 'package:smartory_app/domain/datasources/product_datasource.dart';
import 'package:smartory_app/domain/entities/product.dart';
import 'package:smartory_app/infrastructure/mappers/product_mapper.dart';
import 'package:smartory_app/infrastructure/models/product_model.dart';

class ProductsDatasourceImpl extends ProductDatasource {
  late final Dio dio;

  ProductsDatasourceImpl()
    : dio = Dio(
        BaseOptions(baseUrl: 'http://192.168.100.27:3000/api/products'),
      );

  @override
  Future<Product?> getProductById(String id) async {
    final response = await dio.get('');
    return response.data;
  }

  @override
  Future<List<Product>?> getProducts() async {
    try {
      final response = await dio.get('');
      final data = response.data;
      final products = (data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
      return products.map((p) => ProductMapper.toEntity(p)).toList();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Product>?> getProductsByName(String name) async {
    try {
      final response = await dio.get('/$name');
      final data = response.data;
      final products = (data as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
      return products.map((p) => ProductMapper.toEntity(p)).toList();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
