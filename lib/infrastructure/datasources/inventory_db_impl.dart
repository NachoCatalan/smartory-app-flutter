import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smartory_app/domain/datasources/inventory_datasource.dart';
import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/infrastructure/dtos/create_item_dto.dart';
import 'package:smartory_app/infrastructure/mappers/mappers.dart';
import 'package:smartory_app/infrastructure/models/models.dart';

class InventoryDbDatasourceImpl extends InventoryDatasource {
  late final Dio dio;
  final Future<String?> Function() getValidAccessToken;

  InventoryDbDatasourceImpl({required this.getValidAccessToken})
    : dio = Dio(
        BaseOptions(baseUrl: 'http://192.168.100.27:3000/api/inventory'),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await getValidAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
      ),
    );
  }

  @override
  Future<void> addItem(InventoryItem item) async {
    try {
      final createItemDto = CreateItemDto(
        productId: item.product.id,
        quantity: item.quantity,
        expirationDate: item.expirationDate,
      );
      await dio.post('', data: createItemDto.toJson());
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> editItem(InventoryItem item) {
    // TODO: implement editProduct
    throw UnimplementedError();
  }

  @override
  Future<Inventory> getMyInventory() async {
    try {
      final response = await dio.get('');
      final data = response.data;
      // Mapear a model
      final inventoryModel = InventoryModel.fromJson(data);
      // Convertir a entidad
      return InventoryMapper.toEntity(
        inventoryModel,
      ); // Retornar listado de items
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
  Future<void> removeItem(int itemId) async {
    try {
      await dio.delete('/$itemId');
    } on DioException catch (e) {
      final message = e.message;
      throw Exception(message);
    }
  }

  @override
  Future<void> toggleIsFavorite(String itemId) {
    // TODO: implement toggleIsFavorite
    throw UnimplementedError();
  }

  @override
  Future<List<InventoryInstruction>> convertAudioToInstructions(
    String audioPath,
  ) async {
    try {
      final file = File(audioPath);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: 'audio-instructions.m4a',
        ),
      });

      final response = await dio.post(
        '/process-audio',
        data: formData,
        options: Options(connectTimeout: Duration(seconds: 20)),
      );
      final data = response.data;
      final inventoryInstructionsModel = (data as List).map((instruction) {
        return InventoryInstructionModel.fromJson(instruction);
      }).toList();
      return inventoryInstructionsModel.map((model) {
        return InventoryInstructionMapper.toEntity(model);
      }).toList();
    } on DioException catch (e) {
      // Manejar error cuando el tiempo exceda de los 20 segundos
      throw Exception('Error al enviar el audio ${e.message}');
    }
  }

  @override
  Future<void> processInstructions(
    List<InventoryInstruction> inventoryInstructions,
  ) async {
    try {
      await dio.post(
        '/process-instructions',
        data: inventoryInstructions
            .map((instruction) => instruction.toJson())
            .toList(),
      );
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<InventoryItem>?> getItemsByName(String name) async {
    try {
      final response = await dio.get('/match/$name');
      final data = response.data;
      final items = (data as List)
          .map((data) => InventoryItemModel.fromJson(data))
          .toList();
      return items.map((item) => InventoryItemMapper.toEntity(item)).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
