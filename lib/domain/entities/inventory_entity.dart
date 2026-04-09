
import 'package:smartory_app/domain/entities/inventory_product_entity.dart';

class Inventory {

  final String id;
  //TODO: Implementar asociacion con User
  //final User user;
  final List<InventoryProduct>? products;

  Inventory({
    required this.id,
    this.products
  });

}