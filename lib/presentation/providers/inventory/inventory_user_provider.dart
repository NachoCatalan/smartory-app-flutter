import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/presentation/providers/repositories/inventory_repository_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_user_provider.freezed.dart';

// 1. State
@freezed
abstract class InventoryState with _$InventoryState {
  // UUID del usuario
  const factory InventoryState({
    required Inventory inventory,
    List<InventoryItem>? searchedItems,
  }) = _InventoryState;
}

// 2. Notifier
class InventoryNotifier extends AsyncNotifier<InventoryState> {
  @override
  Future<InventoryState> build() async {
    final inventory = await ref
        .read(inventoryRepositoryProvider)
        .getMyInventory();
    return InventoryState(inventory: inventory);
  }

  Future<void> loadInventory() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final inventory = await ref
          .read(inventoryRepositoryProvider)
          .getMyInventory();
      return InventoryState(inventory: inventory);
    });
  }

  Future<void> addItem(InventoryItem item) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(inventoryRepositoryProvider).addItem(item);
      final newInventory = await ref
          .read(inventoryRepositoryProvider)
          .getMyInventory();
      return InventoryState(inventory: newInventory);
    });
  }

  Future<void> removeItem(int itemId) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(inventoryRepositoryProvider).removeItem(itemId);
      final newInventory = await ref
          .read(inventoryRepositoryProvider)
          .getMyInventory();
      return InventoryState(inventory: newInventory);
    });
  }

  Future<void> processInstructions(
    List<InventoryInstruction> instructions,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref
          .read(inventoryRepositoryProvider)
          .processInstructions(instructions);
      final newInventory = await ref
          .read(inventoryRepositoryProvider)
          .getMyInventory();
      return InventoryState(inventory: newInventory);
    });
  }

  Future<void> searchItemsByName(String name) async {
    if (name.trim().isEmpty) {
      state = AsyncData(state.value!.copyWith(searchedItems: null));
      return;
    }
    final searchedItems = await ref
        .read(inventoryRepositoryProvider)
        .getItemsByName(name.trim());

    state = AsyncData(state.value!.copyWith(searchedItems: searchedItems));
  }
}

// 3. Provider
final inventoryProvider =
    AsyncNotifierProvider<InventoryNotifier, InventoryState>(
      InventoryNotifier.new,
    );
