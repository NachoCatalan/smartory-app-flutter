// 1. State

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartory_app/domain/entities/entities.dart';
import 'package:smartory_app/domain/repositories/inventory_repository.dart';
import 'package:smartory_app/infrastructure/datasources/inventory_db_impl.dart';
import 'package:smartory_app/infrastructure/repositories/inventory_repository_impl.dart';
import 'package:smartory_app/presentation/providers/auth_provider.dart';

class InventoryState {
  // UUID del usuario
  final Inventory inventory;

  InventoryState({
    required this.inventory,
  });

  InventoryState copyWith({
    Inventory? inventory,
  }) => InventoryState(
    inventory: inventory ?? this.inventory,
  );
}

// 2. Notifier

class InventoryNotifier extends AsyncNotifier<InventoryState> {
  @override
  Future<InventoryState> build() async {
    final inventory = await ref.read(inventoryRepositoryProvider).getMyInventory();
    return InventoryState(inventory: inventory);
  }

  Future<void> loadInventory() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final inventory = await ref.read(inventoryRepositoryProvider).getMyInventory();
      return InventoryState(inventory: inventory);
    });
  }
}

final inventoryProvider = AsyncNotifierProvider<InventoryNotifier, InventoryState>(
  InventoryNotifier.new
);

// 3. Provider

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final datasource = InventoryDbDatasourceImpl(
    getValidAccessToken: ref.read(authProvider.notifier).getValidAccessToken,
  );
  return InventoryRepositoryImpl(datasource: datasource);
});
