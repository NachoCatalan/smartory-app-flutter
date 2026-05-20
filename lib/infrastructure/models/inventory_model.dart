import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/infrastructure/mappers/mappers.dart';
import 'package:smartory_app/infrastructure/models/inventory_item_model.dart';

class InventoryModel {
  final int id;
  final List<InventoryItem>? items;

  InventoryModel({required this.id, this.items});

  factory InventoryModel.fromJson(Map<String, dynamic> json) => InventoryModel(
    id: json['id'],
    items: (json['items'] as List)
        .map(
          (item) =>
              InventoryItemMapper.toEntity(InventoryItemModel.fromJson(item)),
        )
        .toList(),
  );
}
