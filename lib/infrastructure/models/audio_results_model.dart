import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/infrastructure/mappers/product_mapper.dart';
import 'package:smartory_app/infrastructure/models/product_model.dart';

class InventoryInstructionModel {
  final String productToFind;
  final String action;
  final List<Product> matches;
  final double quantity;
  final String unit;
  final Status status;
  final String? message;

  InventoryInstructionModel({
    required this.action,
    this.matches = const [],
    required this.quantity,
    required this.unit,
    required this.status,
    this.message,
    required this.productToFind,
  });

  static InventoryInstructionModel fromJson(Map<String, dynamic> json) {
    final productJson = json['product'];

    List<Product> matches = [];

    if (productJson is List) {
      matches = productJson
          .map((item) => ProductMapper.toEntity(ProductModel.fromJson(item)))
          .toList();
    }

    if (productJson is Map<String, dynamic>) {
      matches = [ProductMapper.toEntity(ProductModel.fromJson(productJson))];
    }

    return InventoryInstructionModel(
      action: json['action'],
      matches: matches,
      quantity: json['quantity'].toDouble(),
      unit: json['unit'],
      status: Status.pending,
      message: json['message'],
      productToFind: json['productToFind'],
    );
  }
}

enum InventoryInstructionType { add, update, remove }

enum Status { pending, confirmed, rejected, applied }
