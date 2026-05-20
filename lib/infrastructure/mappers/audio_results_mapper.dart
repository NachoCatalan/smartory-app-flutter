import 'package:smartory_app/domain/entities/inventory_instruction.dart';
import 'package:smartory_app/infrastructure/models/audio_results_model.dart';

class InventoryInstructionMapper {
  static InventoryInstruction toEntity(InventoryInstructionModel model) {
    return InventoryInstruction(
      productToFind: model.productToFind,
      action: model.action,
      matches: model.matches,
      quantity: model.quantity.toDouble(),
      unit: model.unit,
      status: model.status,
      message: model.message,
    );
  }
}
