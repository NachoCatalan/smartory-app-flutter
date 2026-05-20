import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/infrastructure/models/audio_results_model.dart';

class InventoryInstruction {
  final String action;
  final String productToFind;
  final List<Product> matches;
  final double quantity;
  final String unit;
  final Status status;
  final String? message;

  InventoryInstruction({
    required this.action,
    required this.quantity,
    required this.unit,
    required this.status,
    this.message,
    required this.productToFind,
    this.matches = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'productToFind': productToFind,
      'product': matches.isNotEmpty ? matches.first.toJson() : null,
      'quantity': quantity,
      'unit': unit,
      'status': status.name,
      'message': message,
    };
  }
}
