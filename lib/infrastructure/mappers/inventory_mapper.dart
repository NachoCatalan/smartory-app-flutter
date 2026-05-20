import 'package:smartory_app/domain/entities/entities.dart';

import 'package:smartory_app/infrastructure/models/models.dart';

class InventoryMapper {
  static Inventory toEntity(InventoryModel model) =>
      Inventory(id: model.id, items: model.items);
}
