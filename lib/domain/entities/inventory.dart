
import 'package:smartory_app/domain/entities/entities.dart';

class Inventory {

  final int id;
  final List<InventoryItem>? items;

  Inventory({
    required this.id,
    this.items
  });

}