

import 'package:smartory_app/domain/entities/product_entity.dart';

class InventoryProduct {

  final String id;
  final Product product;
  final double quantity;
  final DateTime? expirationDate;
  
  InventoryProduct({
    required this.id,
    required this.product,
    required this.quantity,
    this.expirationDate,
  });
  
}