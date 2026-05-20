import 'package:smartory_app/domain/entities/product.dart';
import 'package:smartory_app/infrastructure/dtos/create_item_dto.dart';

class InventoryItem {
  final int? id;
  final Product product;
  final double quantity;
  final DateTime? expirationDate;
  final bool isFavorite;
  final double? totalAmount;
  final double? remainingAmount;
  final AmountUnit? amountUnit;

  InventoryItem({
    this.id,
    required this.product,
    this.quantity = 1.0,
    this.expirationDate,
    this.isFavorite = false,
    this.totalAmount,
    this.remainingAmount,
    this.amountUnit,
  });
}
