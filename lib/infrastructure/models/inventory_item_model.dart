import 'package:smartory_app/domain/entities/product.dart';
import 'package:smartory_app/infrastructure/dtos/dtos.dart';
import 'package:smartory_app/infrastructure/mappers/mappers.dart';
import 'package:smartory_app/infrastructure/models/models.dart';

class InventoryItemModel {
  final int id;
  final Product product;
  final double quantity;
  final double totalAmount;
  final double remainingAmount;
  final AmountUnit amountUnit;
  final DateTime? expirationDate;
  final bool isFavorite;

  InventoryItemModel({
    required this.id,
    required this.product,
    required this.quantity,
    required this.totalAmount,
    required this.remainingAmount,
    required this.amountUnit,
    this.expirationDate,
    required this.isFavorite,
  });

  static InventoryItemModel fromJson(Map<String, dynamic> json) =>
      InventoryItemModel(
        id: json['id'],
        product: ProductMapper.toEntity(ProductModel.fromJson(json['product'])),
        quantity: json['quantity'].toDouble(),
        totalAmount: json['totalAmount'].toDouble(),
        remainingAmount: json['remainingAmount'].toDouble(),
        amountUnit: AmountUnit.values.firstWhere(
          (value) => value.name == json['amountUnit'],
        ),
        expirationDate: json['expirationDate'] != null
            ? DateTime.parse(json['expirationDate'])
            : null,
        isFavorite: json['isFavorite'],
      );
}
