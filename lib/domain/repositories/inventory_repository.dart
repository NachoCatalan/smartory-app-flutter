import 'package:smartory_app/domain/entities/entities.dart';

abstract class InventoryRepository {
  Future<InventoryItem?> getInventoryItemById(String id);

  Future<Inventory> getMyInventory();

  Future<void> addItem(InventoryItem item);

  Future<void> removeItem(int itemId);

  Future<void> editItem(InventoryItem item);

  Future<void> toggleIsFavorite(String itemId);

  Future<List<InventoryInstruction>> convertAudioToInstructions(
    String audioPath,
  );
  Future<void> processInstructions(
    List<InventoryInstruction> inventoryInstructions,
  );
  Future<List<InventoryItem>?> getItemsByName(String name);
}
