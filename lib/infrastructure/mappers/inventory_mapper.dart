import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/infrastructure/mappers/product_mapper.dart';
import 'package:smartory_app/infrastructure/models/inventory_model.dart';
import 'package:smartory_app/infrastructure/models/product_model.dart';

class InventoryMapper {
  static Inventory toEntity(InventoryModel model) => 
    Inventory(
    id: model.id,
    items: model.items
        ?.map(
          (item) => InventoryItem(
            id: item['id'],
            product: ProductMapper.toEntity(
              ProductModel.fromJson(item['product'])
            ),
            quantity: item['quantity'].toDouble(),
          ),
        )
        .toList(),
  );
}
