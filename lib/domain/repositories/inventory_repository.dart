
import 'package:smartory_app/domain/entities/entities.dart';

abstract class InventoryRepository {

  Future<InventoryItem?> getInventoryItemById(String id);

  Future<Inventory> getMyInventory();

  Future<void> addItem(InventoryItem item);

  Future<void> removeItem(String productId);

  Future<void> editProduct(InventoryItem item);

  Future<void> toggleIsFavorite(String itemId);

}