import 'package:smartory_app/domain/datasources/inventory_datasource.dart';
import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl extends InventoryRepository {
  final InventoryDatasource datasource;

  InventoryRepositoryImpl({required this.datasource});

  @override
  Future<void> addItem(InventoryItem item) async {
    await datasource.addItem(item);
  }

  @override
  Future<void> editItem(InventoryItem item) async {
    await datasource.editItem(item);
  }

  @override
  Future<InventoryItem> getInventoryItemById(String id) async {
    throw UnimplementedError('Not implemented');
  }

  @override
  Future<Inventory> getMyInventory() {
    return datasource.getMyInventory();
  }

  @override
  Future<void> removeItem(int itemId) async {
    await datasource.removeItem(itemId);
  }

  @override
  Future<void> toggleIsFavorite(String itemId) async {
    await datasource.toggleIsFavorite(itemId);
  }

  @override
  Future<List<InventoryInstruction>> convertAudioToInstructions(
    String audioPath,
  ) async {
    return await datasource.convertAudioToInstructions(audioPath);
  }

  @override
  Future<void> processInstructions(
    List<InventoryInstruction> inventoryInstructions,
  ) async {
    await datasource.processInstructions(inventoryInstructions);
  }

  @override
  Future<List<InventoryItem>?> getItemsByName(String name) async {
    return await datasource.getItemsByName(name);
  }
}
