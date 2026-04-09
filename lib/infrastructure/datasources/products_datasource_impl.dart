
import 'package:dio/dio.dart';

import 'package:smartory_app/domain/datasources/product_datasource.dart';
import 'package:smartory_app/domain/entities/product_entity.dart';

class ProductsDatasourceImpl extends ProductDatasource {

  late final Dio dio;

  ProductsDatasourceImpl()
    : dio = Dio(BaseOptions(
      baseUrl: 'http://192.168.1.9',
    )
  );
  

  @override
  Future<Product?> getProductById(String id) async {
    final response = await dio.get('');
    return response.data;
  }

  @override
  Future<List<Product>> getProducts() {
    // TODO: implement getProducts
    throw UnimplementedError();
  }
}