import 'package:dio/dio.dart';
import 'package:smartory_app/domain/datasources/inventory_datasource.dart';
import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/infrastructure/mappers/inventory_mapper.dart';
import 'package:smartory_app/infrastructure/models/inventory_model.dart';

class InventoryDbDatasourceImpl extends InventoryDatasource {
  late final Dio dio;
  final Future<String?> Function() getValidAccessToken;

  InventoryDbDatasourceImpl({required this.getValidAccessToken})
    : dio = Dio(BaseOptions(baseUrl: 'http://192.168.100.27:3000/api')) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await getValidAccessToken();
          if ( accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        }
      ),
    );
  }

  @override
  Future<void> addItem(InventoryItem item) {
    // TODO: implement addItem
    throw UnimplementedError();
  }

  @override
  Future<void> editProduct(InventoryItem item) {
    // TODO: implement editProduct
    throw UnimplementedError();
  }

  @override
  Future<Inventory> getMyInventory() async {
    try {
      final response = await dio.get('/inventory');
      final data = response.data;
      // Mapear a model
      final inventoryModel = InventoryModel.fromJson(data);
      // Convertir a entidad
      return InventoryMapper.toEntity(inventoryModel);     // Retornar listado de items
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<InventoryItem?> getInventoryItemById(String id) {
    // TODO: implement getInventoryItemById
    throw UnimplementedError();
  }

  @override
  Future<void> removeItem(String productId) {
    // TODO: implement removeItem
    throw UnimplementedError();
  }

  @override
  Future<void> toggleIsFavorite(String itemId) {
    // TODO: implement toggleIsFavorite
    throw UnimplementedError();
  }
}
