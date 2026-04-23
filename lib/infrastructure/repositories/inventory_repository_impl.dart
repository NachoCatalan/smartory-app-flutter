

import 'package:smartory_app/domain/datasources/inventory_datasource.dart';
import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl extends InventoryRepository {

  final InventoryDatasource datasource;

  InventoryRepositoryImpl({required this.datasource});


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
  Future<InventoryItem> getInventoryItemById(String id) {
    // TODO: implement getInventoryItemById
    throw UnimplementedError();
  }

  @override
  Future<Inventory> getMyInventory() {
    return datasource.getMyInventory();
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