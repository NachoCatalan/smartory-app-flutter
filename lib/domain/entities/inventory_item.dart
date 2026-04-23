

import 'package:smartory_app/domain/entities/product.dart';

class InventoryItem {

  final int id;
  final Product product;
  final double quantity;
  final DateTime? expirationDate;
  final bool isFavorite;
  
  InventoryItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.expirationDate,
    this.isFavorite = false,
  });
  
}