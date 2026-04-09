
import 'package:smartory_app/domain/entities/inventory_product_entity.dart';

abstract class InventoryRepository {

  Future<InventoryProduct?> getInventoryItemById(String id);

  Future<List<InventoryProduct>> getInventoryProducts();

  Future<void> addProduct(InventoryProduct item);

  Future<void> removeProduct(String productId);
  
}