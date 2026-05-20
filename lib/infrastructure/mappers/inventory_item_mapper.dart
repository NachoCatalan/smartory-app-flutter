import 'package:smartory_app/domain/entities/inventory_item.dart';
import 'package:smartory_app/infrastructure/models/models.dart';

class InventoryItemMapper {
  static InventoryItem toEntity(InventoryItemModel model) => InventoryItem(
    id: model.id,
    product: model.product,
    quantity: model.quantity,
    amountUnit: model.amountUnit,
    expirationDate: model.expirationDate,
    isFavorite: model.isFavorite,
    remainingAmount: model.remainingAmount,
    totalAmount: model.totalAmount,
  );
}
